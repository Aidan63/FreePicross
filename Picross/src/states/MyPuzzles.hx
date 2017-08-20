package states;

import luxe.States;
import luxe.Visual;
import luxe.Color;
import luxe.Vector;
import luxe.Rectangle;
import luxe.Parcel;
import luxe.ParcelProgress;
import ui.Button;
import ui.GridView;

class MyPuzzles extends State
{
    private var parcel : Parcel;
    private var listenPuzzleSelected : String;

    private var gridView : GridView;
    private var bttnCreate : Button;
    private var bttnHome : Button;

    private var panel1 : Visual;
    private var panel2 : Visual;
    private var activePanel : Visual;

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

        bttnHome.destroy();
        bttnCreate.destroy();
        panel1.destroy();
    }

    private function assets_loaded(_parcel : Parcel)
    {
        gridView = new GridView({
            boundary : new Rectangle(40, 40, 580, 540),
            columns  : 4,
            x_offset : 20, y_offset : 20,
            x_sep    : 20, y_sep    : 20,
            items : [ for (i in 0...17) new Visual({
                size : new Vector(120, 120),
                color : Color.random(),
                depth : 3
            }) ]
        });

        var labelPos = [ new Vector(240, 30), new Vector(240, 30), new Vector(240, 50) ];
        var labelCol = [ new Color(0.54, 0.54, 0.54, 1), new Color(0.54, 0.54, 0.54, 1), new Color(0.54, 0.54, 0.54, 1) ];
        var texCol = [ new Color(0.86, 0.86, 0.86, 1), new Color(0.72, 0.72, 0.72, 1), new Color(0.72, 0.72, 0.72, 1) ];
        var texUVs = [ new luxe.Rectangle(0  , 0, 80, 80), new luxe.Rectangle(80 , 0, 80, 80), new luxe.Rectangle(160, 0, 80, 80) ];

        bttnHome = new Button({
            name : 'bttnHome',
            texture : Luxe.resources.texture('assets/images/ui/roundedButton.png'),
            depth : 3,
            pos : new Vector(40, 600),
            size : new Vector(80, 80),
            top : 30, left : 30, bottom : 30, right : 30,
            labelOffsets : labelPos,
            labelColors : labelCol,
            textureUVs : texUVs,
            textureColors : texCol
        });

        bttnCreate = new Button({
            name : 'bttnCreate',
            texture : Luxe.resources.texture('assets/images/ui/roundedButton.png'),
            depth : 3,
            pos : new Vector(140, 600),
            size : new Vector(480, 80),
            top : 30, left : 30, bottom : 30, right : 30,
            labelOffsets : labelPos,
            labelColors : labelCol,
            textureUVs : texUVs,
            textureColors : texCol,
            label : new luxe.Text({
                name : 'bttnCreateText',
                text : 'Create',
                point_size : 32,
                depth : 4,
                align : center,
                align_vertical : center
            })
        });

        panel1 = ui.creators.MyPuzzles.previewPanel();
        panel2 = ui.creators.MyPuzzles.previewPanel();

        panel1.pos.set_xy(660, -640);
        panel2.pos.set_xy(660, -640);
        
        listenPuzzleSelected = gridView.events.listen('item.clicked', onItemSelected);
    }

    private function onItemSelected(_number : Int)
    {
        if (activePanel == null)
        {
            activePanel = panel1;
            luxe.tween.Actuate.tween(activePanel.pos, 0.25, { y : 40 });
        }
        else
        {
            luxe.tween.Actuate.tween(activePanel.pos, 0.25, { y : 720 });
            activePanel.id == panel1.id ? activePanel = panel2 : activePanel = panel1;

            activePanel.pos.set_xy(660, -640);
            luxe.tween.Actuate.tween(activePanel.pos, 0.25, { y : 40 });
        }
    }
}
