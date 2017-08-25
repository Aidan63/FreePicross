package states.game;

import luxe.States;
import luxe.Parcel;
import luxe.Visual;
import luxe.ParcelProgress;
import luxe.Color;
import game.PuzzleState;
import data.PuzzleInfo;

class GameState extends State
{
    private var info : PuzzleInfo;

    private var puzzle : Visual;

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
        Luxe.timer.schedule(2, function() {
            puzzle.add(new components.MousePress ({ name : 'mouse' }));

            hud = ui.creators.Game.createHUD();
        });

        // Connect listeners to the puzzle.

        // Connect listeners to the HUD.
    }
}
