package states.game;

import luxe.States;
import luxe.Parcel;
import luxe.ParcelProgress;
import luxe.Color;
import game.PuzzleState;
import data.PuzzleInfo;

class GameState extends State
{
    private var info : PuzzleInfo;

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
            bytes : [
                { id : 'assets/puzzles/ics.puzzle' }
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
        PuzzleState.loadPuzzle(info);
    }

    override public function update(_dt : Float)
    {
        /*
        if (Luxe.input.keypressed(Key.space))
        {
            var data : components.Puzzle = cast PuzzleState.puzzle.get('puzzle');
            utils.PuzzleSaver.save(data.active, '/media/aidan/archive/projects/FreePicross/Picross/assets/puzzles/test.puzzle');
        }
        if (Luxe.input.keypressed(Key.lshift))
        {
            PuzzleState.loadPuzzle('');
        }
        */
    }
}
