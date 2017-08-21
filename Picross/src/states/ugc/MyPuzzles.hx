package states.ugc;

import luxe.States;
import luxe.Visual;
import luxe.Text;
import luxe.Color;
import luxe.Vector;
import luxe.Rectangle;
import luxe.Parcel;
import luxe.ParcelProgress;
import ui.Button;
import ui.GridView;
import data.PuzzleInfo;
import phoenix.Texture;

using utils.EntityHelper;

class MyPuzzles extends State
{
    /**
     *  The parcel which will load all required assets for this scene.
     */
    private var parcel : Parcel;

    /**
     *  The grid which will hold all of the puzzle preview icons.
     */
    private var gridView : GridView;

    /**
     *  Button which will open a popup to create a new puzzle.
     */
    private var bttnCreate : Button;

    /**
     *  Button which will return the user to the main menu.
     */
    private var bttnHome : Button;

    /**
     *  The first preview panel.
     */
    private var panel1 : Visual;

    /**
     *  The second preview panel.
     */
    private var panel2 : Visual;

    /**
     *  Points to the current preview panel.
     */
    private var activePanel : Visual;

    /**
     *  All of textures for the puzzles.
     */
    private var puzzleTextures : Array<Texture>;

    /**
     *  All of the loaded user puzzles.
     */
    private var ugPuzzles : Array<PuzzleInfo>;

    /**
     *  The currently selected puzzle.
     */
    private var selectedID : Int;

    private var listenPuzzleSelected : String;
    private var listenCreateClicked : String;
    private var listenPause : String;

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

        ugPuzzles = [
            utils.storage.PuzzleStorage.load('strawberry'),
            utils.storage.PuzzleStorage.load('277008110')
        ];
    }

    override public function onleave<T>(_data : T)
    {
        Luxe.events.unlisten(listenPause);
        gridView.events.unlisten(listenPuzzleSelected);
        bttnCreate.events.unlisten(listenCreateClicked);

        gridView.destroy();
        bttnHome.destroy();
        bttnCreate.destroy();
        panel1.destroy();
        panel2.destroy();
    }

    private function assets_loaded(_parcel : Parcel)
    {
        // Generate textures from all of the loaded user puzzles.
        puzzleTextures = new Array<Texture>();
        for (puzzle in ugPuzzles)
        {
            var tex = new Texture({
                id : 'puzzleTexture-${puzzle.id}',
                width : puzzle.grid.data[0].length,
                height : puzzle.grid.data.length,
                pixels : puzzle.pixels
            });
            tex.filter_min = tex.filter_mag = nearest;

            puzzleTextures.push(tex);
        }

        // Generate preview icons from those textures for the grid.
        var previews = new Array<Visual>();
        for (tex in puzzleTextures)
        {
            previews.push(new Visual({
                size : new Vector(120, 120),
                texture : tex,
                depth : 3
            }));
        }

        // Creates the grid view, back, and create buttons.
        gridView = new GridView({
            boundary : new Rectangle(40, 40, 580, 540),
            columns  : 4,
            x_offset : 20, y_offset : 20,
            x_sep    : 20, y_sep    : 20,
            items : previews
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

        // Create the preview panels and place them offscreen.
        panel1 = ui.creators.MyPuzzles.previewPanel();
        panel2 = ui.creators.MyPuzzles.previewPanel();

        panel1.pos.set_xy(660, -640);
        panel2.pos.set_xy(660, -640);
        
        // Connect listeners.
        listenPause = Luxe.events.listen('myPuzzles.pause', onPaused);
        listenPuzzleSelected = gridView.events.listen('item.clicked', onItemSelected);
        listenCreateClicked = bttnCreate.events.listen('clicked', onCreateClicked);
    }

    /**
     *  Moves in the panel which is not currently active and set that one to the active panel.
     *  @param _number - 
     */
    private function onItemSelected(_number : Int)
    {
        if (activePanel == null)
        {
            // Move in puzzle for the first time.
            activePanel = panel1;
            luxe.tween.Actuate.tween(activePanel.pos, 0.25, { y : 40 });
        }
        else
        {
            // If a new puzzle has been clicked swap the two puzzle panels.
            if (_number == selectedID) return;

            luxe.tween.Actuate.tween(activePanel.pos, 0.25, { y : 720 });
            activePanel.id == panel1.id ? activePanel = panel2 : activePanel = panel1;

            activePanel.pos.set_xy(660, -640);
            luxe.tween.Actuate.tween(activePanel.pos, 0.25, { y : 40 });
        }

        // Set the now active panels details.
        selectedID = _number;
        updateActivePanel(_number);
    }

    /**
     *  Set the active panels name, description and preview based of the puzzle index provided.
     *  @param _puzzleID The position in the puzzle info and puzzle texture array to get data from.
     */
    private function updateActivePanel(_puzzleID : Int)
    {
        var title       : Text   = cast activePanel.findChild('title');
        var description : Text   = cast activePanel.findChild('description');
        var preview     : Visual = cast activePanel.findChild('preview');

        var puzzle : PuzzleInfo = ugPuzzles[_puzzleID];
        title.text = puzzle.name;
        description.text = puzzle.description;
        preview.texture = puzzleTextures[_puzzleID];
    }

    /**
     *  Event listen functions.
     */

    /**
     *  Pauses or unpauses the myPuzzles state.
     *  @param _event - 
     */
    private function onPaused(_event : { pause : Bool })
    {
        if (_event.pause)
        {
            bttnHome.active = false;
            bttnCreate.active = false;
            gridView.active = false;

            if (activePanel != null)
            {
                activePanel.findChild('bttnPlay').active = false;
                activePanel.findChild('bttnDelete').active = false;
            }
        }
        else
        {
            bttnHome.active = true;
            bttnCreate.active = true;
            gridView.active = true;

            if (activePanel != null)
            {
                activePanel.findChild('bttnPlay').active = true;
                activePanel.findChild('bttnDelete').active = true;
            }
        }
    }

    /**
     *  Opens the create puzzle popup.
     */
    private function onCreateClicked(_)
    {
        machine.enable('myPuzzles_create');
    }
}
