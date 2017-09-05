package states.game;

import luxe.States;
import luxe.Parcel;
import luxe.Visual;
import luxe.Vector;
import luxe.ParcelProgress;
import luxe.Color;
import game.PuzzleState;
import data.PuzzleInfo;
import data.Stats;

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

    /**
     *  the results panel when the puzzle is over.
     *  The success and failed panel both use this variable.
     */
    private var hudResults : Visual;

    /**
     *  Holds the time and number of faults for this current puzzle session.
     */
    private var stats : Stats;

    /**
     *  The sub state machine to hold all of the pause states.
     */
    private var pauseState : States;

    // event listeners
    private var listenPause : String;

    private var listenPauseClicked : String;
    private var listenPrimaryClicked : String;
    private var listenSecondaryClicked : String;

    private var listenCellBrushed : String;
    private var listenCellRemoved : String;
    private var listenCellFault : String;

    private var listenResultsMenu : String;
    private var listenResultsRestart : String;

    override public function onenter<T>(_data : T)
    {
        info = cast _data;

        var parcel = new Parcel({
            textures : [
                { id : 'assets/images/cells.png' },
                { id : 'assets/images/cellFragment.png' },
                { id : 'assets/images/fault.png' },
                { id : 'assets/images/rules.png' },
                { id : 'assets/images/bubblesUp.png' },
                { id : 'assets/images/bubblesDown.png' },
                { id : 'assets/images/ui/buttonPause.png' },
                { id : 'assets/images/ui/paintSelector.png' },
                { id : 'assets/images/ui/roundedButton.png' }
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

    override public function onleave<T>(_data : T)
    {
        cleanup();
    }

    override public function update(_dt : Float)
    {
        // If the puzzle has a mouse component then we assume the game is in progress so the timer should increase.
        if (puzzle != null && puzzle.has('mouse'))
        {
            stats.time += 1 * _dt;
            cast(hud.findChild('label_timer'), luxe.Text).text = stats.formattedTime();
        }
    }

    private function assets_loaded(_parcel : Parcel)
    {
        PuzzleState.init();

        stats = new Stats();

        pauseState = new States({ name : 'game_pause' });
        pauseState.add(new PauseMenu({ name : 'menu' }));

        puzzle = new Visual({ name : 'puzzle' });
        puzzle.add(new components.Puzzle     ({ name : 'puzzle', completedPuzzle : info.grid }));
        puzzle.add(new components.Rules      ({ name : 'rules'        }));
        puzzle.add(new components.Dimensions ({ name : 'dimensions'   }));
        puzzle.add(new components.Display    ({ name : 'display'      }));
        puzzle.origin.set_xy(puzzle.size.x / 2, puzzle.size.y / 2);
        puzzle.pos.set_xy(640, 360);

        puzzle.add(new components.RuleDisplay({ name : 'rule_display' }));
        puzzle.add(new components.Faults     ({ name : 'faults'       }));
        puzzle.add(new components.CellHighlighter({ name : 'cell_highlighter' }));
        puzzle.add(new components.LineHighlighter({ name : 'line_highlighter' }));
        puzzle.add(new components.CellBreaker    ({ name : 'remove_effect'    }));

        utils.Banner.create('Start!', 1);
        Luxe.timer.schedule(2, startPuzzle);
    }

    private function cleanup()
    {
        pauseState.destroy();

        // disconnect listeners to the puzzle.
        Luxe.events.unlisten(listenPause);

        puzzle.events.unlisten(listenCellBrushed);
        puzzle.events.unlisten(listenCellRemoved);
        puzzle.events.unlisten(listenCellFault);

        // disconnect listeners to the HUD.
        hud.findChild('bttn_pause').events.unlisten(listenPauseClicked);
        hud.findChild('bttn_paintPrimary').events.unlisten(listenPrimaryClicked);
        hud.findChild('bttn_paintSecondary').events.unlisten(listenSecondaryClicked);

        puzzle.destroy();
        hud.destroy();

        puzzle = null;
        hud = null;

        if (hudResults != null)
        {
            hudResults.findChild('bttn_menu').events.unlisten(listenResultsMenu);
            hudResults.findChild('bttn_restart').events.unlisten(listenResultsRestart);

            hudResults.destroy();
            hudResults = null;
        }
    }

    private function startPuzzle()
    {
        puzzle.add(new components.MousePress ({ name : 'mouse' }));

        hud = ui.creators.Game.createHUD();
        hud.pos.set_xy(-128, 0);
        luxe.tween.Actuate.tween(hud.pos, 0.25, { x : 0 });

        listenPause = Luxe.events.listen('game.pause', onPaused);

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

        pauseState.set('menu', true);
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
     *  When the menu button is pressed switch back to myPuzzles.
     *  TODO : Makes it return to the last used menu once other menus which use the game state are added.
     */
    private function onResultsMenuPressed(_)
    {
        machine.set('myPuzzles');
    }

    /**
     *  When reset is clicked cleanup all of current game entities.
     *  Then called the assets_loaded function to create new versions.
     */
    private function onResultsRestartPressed(_)
    {
        cleanup();
        assets_loaded(null);
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
            endPuzzle();
            puzzleCompleted();
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
        puzzle.events.unlisten(listenCellBrushed);
        puzzle.events.unlisten(listenCellRemoved);
        puzzle.events.unlisten(listenCellFault);

        if (puzzle.has('mouse')) puzzle.remove('mouse');
        if (puzzle.has('gamepad')) puzzle.remove('gamepad');
        if (puzzle.has('rule_display')) cast(puzzle.get('rule_display'), components.RuleDisplay).fadeOut();

        luxe.tween.Actuate.tween(hud.pos, 0.25, { x : -128 });

        hud.findChild('bttn_pause').events.unlisten(listenPauseClicked);
        hud.findChild('bttn_paintPrimary').events.unlisten(listenPauseClicked);
        hud.findChild('bttn_paintSecondary').events.unlisten(listenPauseClicked);
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

            hudResults = ui.creators.Game.createResults();
            hudResults.pos.set_xy(1280, 40);

            // Connect the reset and menu listen events to the buttons.
            listenResultsMenu    = hudResults.findChild('bttn_menu').events.listen('released', onResultsMenuPressed);
            listenResultsRestart = hudResults.findChild('bttn_restart').events.listen('released', onResultsRestartPressed);

            luxe.tween.Actuate.tween(hudResults.pos, 0.5, { x : 680 });
        });
    }

    /**
     *  Called when the puzzle has been failed.
     */
    private function puzzleFailed()
    {
        //
    }


    /**
     *  Pause related events
     */
    private function onPaused(_event : { state : Bool })
    {
        PuzzleState.cursor.mouse = None;

        if (_event.state)
        {
            disableHUD();
            if (puzzle.has('mouse')) puzzle.remove('mouse');
            
        }
        else
        {
            enabledHUD();
            if (!puzzle.has('mouse')) puzzle.add(new components.MousePress ({ name : 'mouse' }));
        }
    }

    private function disableHUD()
    {
        for (child in hud.children)
        {
            child.active = false;
        }
    }

    private function enabledHUD()
    {
        for (child in hud.children)
        {
            child.active = true;
        }
    }
}
