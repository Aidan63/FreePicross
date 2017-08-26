package states.game;

import luxe.States;
import luxe.Parcel;
import luxe.Visual;
import luxe.Vector;
import luxe.ParcelProgress;
import luxe.Color;
import game.PuzzleState;
import data.PuzzleInfo;

import utils.Effect;
import utils.PuzzleHelper;

using utils.EntityHelper;

class GameState extends State
{
    /**
     *  The current active puzzle info.
     */
    private var info : PuzzleInfo;

    /**
     *  The puzzle entity.
     */
    private var puzzle : Visual;

    /**
     *  The game UI entity.
     */
    private var hud : Visual;

    // event listeners
    private var listenPauseClicked : String;
    private var listenPrimaryClicked : String;
    private var listenSecondaryClicked : String;

    private var listenCellBrushed : String;
    private var listenCellRemoved : String;
    private var listenCellFault : String;

    override public function onenter<T>(_data : T)
    {
        info = cast _data;

        var parcel = new Parcel({
            textures : [
                { id : 'assets/images/cells.png' },
                { id : 'assets/images/cellFragment.png' },
                { id : 'assets/images/fault.png' },
                { id : 'assets/images/RuleCircle.png' },
                { id : 'assets/images/RuleSquare.png' },
                { id : 'assets/images/bubblesUp.png' },
                { id : 'assets/images/bubblesDown.png' },
                { id : 'assets/images/ui/buttonPause.png' },
                { id : 'assets/images/ui/paintSelector.png' }
            ],
            jsons : [
                { id : 'assets/data/animations/bubbleUp.json' },
                { id : 'assets/data/animations/bubbleDown.json' },
                { id : 'assets/data/animations/paintSelector.json' }
            ],
            fonts : [
                { id : 'assets/fonts/odin.fnt' }
            ]
        });

        new ParcelProgress({
            parcel : parcel,
            background : new Color(1, 1, 1, 0.85),
            oncomplete : assets_loaded
        });

        parcel.load();
    }

    private function assets_loaded(_parcel : Parcel)
    {
        PuzzleState.init();

        puzzle = new Visual({ name : 'puzzle' });
        puzzle.add(new components.Puzzle     ({ name : 'puzzle', completedPuzzle : info.grid }));
        puzzle.add(new components.Rules      ({ name : 'rules'        }));
        puzzle.add(new components.Dimensions ({ name : 'dimensions'   }));
        puzzle.add(new components.Display    ({ name : 'display'      }));
        puzzle.add(new components.RuleDisplay({ name : 'rule_display' }));
        puzzle.add(new components.Faults     ({ name : 'faults'       }));
        puzzle.add(new components.CellHighlighter({ name : 'cell_highlighter' }));
        puzzle.add(new components.LineHighlighter({ name : 'line_highlighter' }));
        puzzle.add(new components.CellBreaker    ({ name : 'remove_effect'    }));

        utils.Banner.create('Start!', 1);
        Luxe.timer.schedule(2, startPuzzle);
    }

    private function startPuzzle()
    {
        puzzle.add(new components.MousePress ({ name : 'mouse' }));

        hud = ui.creators.Game.createHUD();
        hud.pos.set_xy(-128, 0);
        luxe.tween.Actuate.tween(hud.pos, 0.25, { x : 0 });

        // Connect listeners to the puzzle.
        listenCellBrushed = puzzle.events.listen('cell.brushed', checkCompletedPuzzle);
        listenCellRemoved = puzzle.events.listen('cell.removed', checkCompletedPuzzle);
        listenCellFault   = puzzle.events.listen('cell.fault'  , checkPuzzleFailed);

        // Connect listeners to the HUD.
        listenPauseClicked     = hud.findChild('bttn_pause').events.listen('clicked', onPausePressed);
        listenPrimaryClicked   = hud.findChild('bttn_paintPrimary').events.listen('clicked', onPrimaryPressed);
        listenSecondaryClicked = hud.findChild('bttn_paintSecondary').events.listen('clicked', onSecondaryPressed);
    }

    /**
     *  Button listener functions
     */

    /**
     *  Plays a select effect when pressed. TODO : Actually pause the game.
     */
    private function onPausePressed(_)
    {
        var pause : Visual = cast hud.findChild('bttn_pause');

        Effect.select(pause.transform.world.pos.clone(), pause.size.clone(), new Vector(12, 12));
    }

    /**
     *  Sets the current colour to Primary, slide the selector to the primary paint button and play a select effect.
     */
    private function onPrimaryPressed(_)
    {
        PuzzleState.color.currentColor = Primary;

        var selector = hud.findChild('bttn_paintSelector');
        var primary : Visual = cast hud.findChild('bttn_paintPrimary');

        // Slide the selector to this button.
        if (selector.has('slide')) selector.remove('slide');
        selector.add(new components.Slider({ name : 'slide', time : 0.25, end : primary.pos, ease : luxe.tween.easing.Quad.easeOut }));

        Effect.select(primary.transform.world.pos.clone(), primary.size.clone(), new Vector(12, 12));
    }

    /**
     *  Sets the current colour to Secondary, slide the selector to the secondary paint button and play a select effect.
     */
    private function onSecondaryPressed(_)
    {
        PuzzleState.color.currentColor = Secondary;

        var selector  = hud.findChild('bttn_paintSelector');
        var secondary : Visual = cast hud.findChild('bttn_paintSecondary');

        // Slide the selector to this button.
        if (selector.has('slide')) selector.remove('slide');
        selector.add(new components.Slider({ name : 'slide', time : 0.25, end : secondary.pos, ease : luxe.tween.easing.Quad.easeOut }));

        Effect.select(secondary.transform.world.pos.clone(), secondary.size.clone(), new Vector(12, 12));
    }

    /**
     *  Puzzle listener functions
     */

    /**
     *  Check if the puzzle has been completed.
     */
    private function checkCompletedPuzzle(_)
    {
        if (PuzzleHelper.puzzleComplete(puzzle.get('puzzle')))
        {
            trace('Puzzle completed!');
            endPuzzle();
            puzzleCompleted();

            //Luxe.events.fire('puzzle.completed');
            //PuzzleState.endPuzzle();
        }
    }

    /**
     *  Checks if the puzzle has been failed.
     */
    private function checkPuzzleFailed(_)
    {
        //
    }

    /**
     *  End game stuff regardless of if the puzzle has been completed or failed.
     */
    private function endPuzzle()
    {
        hud.findChild('bttn_pause').events.unlisten(listenPauseClicked);
        hud.findChild('bttn_paintPrimary').events.unlisten(listenPauseClicked);
        hud.findChild('bttn_paintSecondary').events.unlisten(listenPauseClicked);

        puzzle.events.unlisten(listenCellBrushed);
        puzzle.events.unlisten(listenCellRemoved);
        puzzle.events.unlisten(listenCellFault);

        if (puzzle.has('mouse')) puzzle.remove('mouse');
        if (puzzle.has('gamepad')) puzzle.remove('gamepad');
        if (puzzle.has('rule_display')) cast(puzzle.get('rule_display'), components.RuleDisplay).fadeOut();

        luxe.tween.Actuate.tween(hud.pos, 0.25, { x : -128 });
    }

    /**
     *  Called when the puzzle has been successfully completed.
     */
    private function puzzleCompleted()
    {
        // Slide the puzzle to the center of the screen.
        puzzle.add(new components.Slider({ name : 'move_mid', time : 2, end : new Vector(640, 360), ease : luxe.tween.easing.Quad.easeOut }));

        // After the puzzle has reached the center of the screen.
        Luxe.timer.schedule(2.5, function() {
            Luxe.camera.add(new components.Flash({ name : 'flash', time : 1 }));

            utils.PuzzleHelper.imageFromPixels(puzzle, info.pixels);
            utils.Banner.create('Complete!', 1);
        });

        // Once the 'complete' banner has vanished.
        Luxe.timer.schedule(4.5, function() {
            puzzle.add(new components.Slider({
                name : 'move_mid',
                time : 0.5,
                end  : new Vector(320, 360),
                ease : luxe.tween.easing.Quad.easeOut
            }));

            // Temp create the end ui.
            //ui.results = new ui.game.PuzzleResults();
            //ui.results.moveIn();
        });
    }

    /**
     *  Called when the puzzle has been failed.
     */
    private function puzzleFailed()
    {
        //
    }
}
