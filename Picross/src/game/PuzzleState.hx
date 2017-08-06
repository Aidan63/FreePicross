package game;

import luxe.Visual;
import game.Timer;
import game.Cursor;
import game.ColorSelector;
import game.UI;
import data.PuzzleInfo;
import ui.game.GameUI;
import ui.game.PuzzleResults;

class PuzzleState
{
    public static var info : PuzzleInfo;
    /**
     *  The puzzle entity.
     */
    public static var puzzle : Visual;

    /**
     *  The timer keeping track of the time spent on the puzzle.
     */
    public static var timer : Timer;

    /**
     *  Holds the current colour and mappings to luxe colours.
     */
    public static var color : ColorSelector;

    /**
     *  The cursors current state.
     */
    public static var cursor : Cursor;

    /**
     *  Holds the UI classes used for the game.
     */
    public static var ui : UI;

    public static function init()
    {
        timer  = new Timer({ name : 'puzzle_timer' });
        color  = new ColorSelector();
        cursor = new Cursor();
        ui     = new UI();
    }
    
    /**
     *  Loads the puzzle from the provided location and start a countdown.
     *  @param _puzzleLocation The path to the puzzle file on disk.
     */
    public static function loadPuzzle(_puzzleLocation : String)
    {
        if (puzzle != null)
        {
            puzzle.destroy();
        }

        info = utils.storage.PuzzleStorage.load('strawberry');
        if (info == null)
        {
            trace('NULL');
            return;
        }

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

        //utils.PuzzleHelper.imageFromPixels(puzzle, info.pixels);

        startCountdown();
    }

    /**
     *  Called once the puzzle has been completed.
     */
    public static function endPuzzle()
    {
        // Let everything know the puzzle has been completed.
        Luxe.events.fire('puzzle.completed');

        timer.stop();
        ui.hud.moveOut();

        // Slide the puzzle to the center of the screen.
        puzzle.add(new components.Slider({ name : 'move_mid', time : 2, end : Luxe.screen.mid, ease : luxe.tween.easing.Quad.easeOut }));

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
                end  : Luxe.screen.mid.subtract_xyz(Luxe.screen.mid.x / 2),
                ease : luxe.tween.easing.Quad.easeOut
            }));

            // Temp create the end ui.
            ui.results = new ui.game.PuzzleResults();
            ui.results.moveIn();
        });
    }

    /**
     *  Starts the 'countdown' to when the puzzle starts.
     *  The countdown consists of showing the start banner.
     */
    private static function startCountdown()
    {
        utils.Banner.create('Start!', 1);

        Luxe.timer.schedule(2, startPuzzle, false);
        Luxe.events.fire('puzzle.countdown');
    }

    /**
     *  Starts the actual puzzle.
     *  
     *  Starts the timer and adds a mouse press component to the puzzle.
     *  Creates and moves in the in game UI.
     */
    private static function startPuzzle()
    {
        timer.start();
        puzzle.add(new components.MousePress ({ name : 'mouse' }));

        ui.hud = new GameUI();
        ui.hud.moveIn();

        Luxe.events.fire('puzzle.start');
    }
}
