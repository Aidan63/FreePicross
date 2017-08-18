package states;

import luxe.States;
import luxe.Visual;
import luxe.Color;
import luxe.Parcel;
import luxe.ParcelProgress;

class MyPuzzles extends State
{
    private var parcel : Parcel;
    private var listenPuzzleSelected : String;

    private var gridView : Visual;

    override public function onenter<T>(_data : T)
    {
        parcel = new Parcel({
            textures : [
                { id : 'assets/images/cells.png' },
                { id : 'assets/images/cellFragment.png' },
                { id : 'assets/images/fault.png' },
                { id : 'assets/images/RuleCircle.png' },
                { id : 'assets/images/RuleSquare.png' },
                { id : 'assets/images/ui/paintSelector.png' },
                { id : 'assets/images/ui/buttonExport.png' },
                { id : 'assets/images/ui/roundedPanel.png' },
                { id : 'assets/images/ui/roundedButton.png'}
            ],
            jsons : [
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
        gridView.events.unlisten(listenPuzzleSelected);
        gridView.destroy();
    }

    private function assets_loaded(_parcel : Parcel)
    {
        gridView = new ui.GridView({
            boundary : new luxe.Rectangle(40, 40, 580, 540),
            columns : 4,
            x_offset : 20, y_offset : 20,
            x_sep : 20, y_sep : 20,
            items : [ for (i in 0...5) new Visual({
                size : new luxe.Vector(120, 120),
                color : luxe.Color.random(),
                depth : 3
            }) ]
        });
        
        listenPuzzleSelected = gridView.events.listen('item.clicked', onItemSelected);
    }

    private function onItemSelected(_number : Int)
    {
        trace(_number);
    }
}
