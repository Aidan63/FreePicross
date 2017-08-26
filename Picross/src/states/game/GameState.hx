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
        //PuzzleState.loadPuzzle(info);

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
        puzzle.events.listen('cell.brushed', checkCompletedPuzzle);
        puzzle.events.listen('cell.removed', checkCompletedPuzzle);

        // Connect listeners to the HUD.
        hud.findChild('bttn_pause').events.listen('clicked', onPausePressed);
        hud.findChild('bttn_paintPrimary').events.listen('clicked', onPrimaryPressed);
        hud.findChild('bttn_paintSecondary').events.listen('clicked', onSecondaryPressed);
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

            //Luxe.events.fire('puzzle.completed');
            //PuzzleState.endPuzzle();
        }
    }

    private function endPuzzle()
    {
        if (puzzle.has('mouse')) puzzle.remove('mouse');
        if (puzzle.has('gamepad')) puzzle.remove('gamepad');

        luxe.tween.Actuate.tween(hud.pos, 0.25, { x : -128 });
    }
}
