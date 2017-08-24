package states.designer;

import luxe.States;
import luxe.Parcel;
import luxe.ParcelProgress;
import luxe.Color;
import luxe.Visual;
import luxe.Vector;
import luxe.Rectangle;
import game.PuzzleState;
import ui.creators.DesignerUI;

using utils.EntityHelper;

class DesignerState extends State
{
    /**
     *  The parcel which will load all of the resources needed for the designer.
     */
    private var parcel : Parcel;

    /**
     *  This entity will hold the actual primary and secondary colour puzzle design.
     */
    private var design : Visual;

    /**
     *  The entity will hold the image the completed puzzle will form.
     */
    private var image  : Visual;

    /**
     *  Visual which will hold all of the HUD elements.
     */
    private var hud : Visual;

    /**
     *  The class which holds the size of this puzzle.
     *  It is the data which is sent to this state when it's entered.
     */
    private var size : data.events.PuzzleSize;

    /**
     *  Event listeners.
     */

    private var listenPause : String;
    private var listenExport : String;
    private var listenPixelPainted : String;
    private var listenPixelRemoved : String;
    
    private var listenBttnExport : String;
    private var listenBttnPrimary : String;
    private var listenBttnSecondary : String;
    private var listenBttnPaints : Array<String>;

    override public function onenter<T>(_data : T)
    {
        size = cast _data;

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
        // Unload the parcel resources
        parcel.unload();

        // Unlisten to all events.
        Luxe.events.unlisten(listenPause);
        Luxe.events.unlisten(listenExport);
        image.events.unlisten(listenPixelPainted);
        image.events.unlisten(listenPixelRemoved);

        hud.findChild('ui_export'        ).events.unlisten(listenBttnExport);
        hud.findChild('ui_paintPrimary'  ).events.unlisten(listenBttnPrimary);
        hud.findChild('ui_paintSecondary').events.unlisten(listenBttnSecondary);

        var paintsHolder = hud.findChild('ui_paintsHolder');
        for (i in 0...DesignerUI.paints.length) paintsHolder.findChild('ui_paint$i').events.unlisten(listenBttnPaints[i]);

        // Destroy the relevent entities.
        if (image  != null) image.destroy();
        if (design != null) design.destroy();
        if (hud    != null) hud.destroy();
    }

    private function assets_loaded(_parcel : Parcel)
    {
        PuzzleState.init();

        // Create an entity for the actual puzzle cells.
        design = new Visual({ name : 'design' });
        design.add(new components.designer.PuzzleDesign({ name : 'puzzle', width : size.width, height : size.height }));
        design.add(new components.Dimensions({ name : 'dimensions' }));
        design.add(new components.Display   ({ name : 'display', boundary : new Vector(496, 400) }));
        design.add(new components.SelectedCell({ name : 'cell_selector' }));
        design.add(new components.MousePress({ name : 'mouse' }));
        design.pos.set_xy(344, 296);
        Luxe.draw.rectangle({
            x : design.pos.x - design.origin.x,
            y : design.pos.y - design.origin.y,
            w : design.size.x,
            h : design.size.y,
            color : new Color(0, 0, 0, 0.25)
        });

        // Create an entity for the finished puzzle image.
        image = new Visual({ name : 'image'});
        image.add(new components.designer.PuzzleImage({ name : 'grid', width : size.width, height : size.height }));
        image.add(new components.Dimensions({ name : 'dimensions' }));
        image.add(new components.designer.DesignerDisplay({ name : 'display', boundary : new Rectangle(688, 96, 496, 400) }));
        image.add(new components.MousePress({ name : 'mouse' }));
        image.add(new components.SelectedCell({ name : 'cell_selector' }));
        Luxe.draw.rectangle({ x : image.pos.x, y : image.pos.y, w : image.size.x, h : image.size.y, color : new Color(0, 0, 0, 0.25) });

        // Create the HUD and link up event listeners.
        hud = DesignerUI.create();

        listenPause  = Luxe.events.listen('designer.pause' , onPaused);
        listenExport = Luxe.events.listen('designer.export', onExport);

        listenBttnExport    = hud.findChild('ui_export'        ).events.listen('clicked', onExportMenuClicked);
        listenBttnPrimary   = hud.findChild('ui_paintPrimary'  ).events.listen('clicked', onPaintPrimaryClicked);
        listenBttnSecondary = hud.findChild('ui_paintSecondary').events.listen('clicked', onPaintSecondaryClicked);

        var paintsHolder = hud.findChild('ui_paintsHolder');
        listenBttnPaints = new Array<String>();
        for (i in 0...DesignerUI.paints.length)
        {
            listenBttnPaints.push(paintsHolder.findChild('ui_paint$i').events.listen('clicked', onPaintClicked.bind(_, i)));
        }

        listenPixelPainted = image.events.listen('cell.brushed', onPixelPainted);
        listenPixelRemoved = image.events.listen('cell.removed', onPixelRemoved);
    }

    /**
     *  Game UI events.
     */

    /**
     *  When export is clicked the HUD is disable and a popup is shown with save and export options.
     */
    private function onExportMenuClicked(_)
    {
        machine.enable('designer_pause');
    }

    /**
     *  When the primary paint is selected we set the puzzle state paint to primary and show some click effects.
     */
    private function onPaintPrimaryClicked(_)
    {
        var button   : Visual = cast hud.findChild('ui_paintPrimary');
        var selector : Visual = cast hud.findChild('ui_puzzlePaintSelector');

        PuzzleState.color.currentColor = Primary;

        if (selector.has('slide')) selector.remove('slide');
        selector.add(new components.Slider({ name : 'slide', time : 0.25, end : button.pos, ease : luxe.tween.easing.Quad.easeInOut }));

        utils.Effect.select(button.pos.clone(), button.size.clone(), new Vector(8, 8), hud);
    }

    /**
     *  When the secondary paint is selected we set the puzzle state paint to secondary and show some click effects.
     */
    private function onPaintSecondaryClicked(_)
    {
        var button   : Visual = cast hud.findChild('ui_paintSecondary');
        var selector : Visual = cast hud.findChild('ui_puzzlePaintSelector');

        PuzzleState.color.currentColor = Secondary;

        if (selector.has('slide')) selector.remove('slide');
        selector.add(new components.Slider({ name : 'slide', time : 0.25, end : button.pos, ease : luxe.tween.easing.Quad.easeInOut }));

        utils.Effect.select(button.pos.clone(), button.size.clone(), new Vector(8, 8), hud);
    }

    /**
     *  Set the designer paint ID to that of the pressed paint button and show some click effects.
     *  @param _paintNumber The number ID of the paint clicked.
     */
    private function onPaintClicked(_, _paintNumber : Int)
    {
        var paint    : Visual = cast hud.findChild('ui_paintsHolder').findChild('ui_paint$_paintNumber');
        var selector : Visual = cast hud.findChild('ui_paintsHolder').findChild('ui_designerPaintSelector');

        PuzzleState.color.designerColor = DesignerUI.paints[_paintNumber];

        if (selector.has('slide')) selector.remove('slide');
        selector.add(new components.Slider({ name : 'slide', time : 0.25, end : paint.pos, ease : luxe.tween.easing.Quad.easeInOut }));

        utils.Effect.select(paint.pos.clone(), paint.size.clone(), new Vector(4, 4), hud.findChild('ui_paintsHolder'));
    }

    /**
     *  Grid entity events.
     */
    
    /**
     *  Called when a pixel on the image display is placed.
     *  When this happens we want to the design to use the cell at the same position in the design.
     *  So we tell the design to brush the cell at the provided position.
     *  
     *  @param _position The cell row and column position.
     */
    private function onPixelPainted(_position : data.events.CellPosition)
    {
        design.events.fire('cell.brushed', _position);
    }

    /**
     *  Called when a pixel on the image display is removed.
     *  When this happens we want to remove the cell in the design of the same position.
     *  So we tell the design to remove the cell at the provided position.
     *  
     *  @param _position The cell row and column position.
     */
    private function onPixelRemoved(_position : data.events.CellPosition)
    {
        design.events.fire('cell.removed', _position);
    }

    /**
     *  Misc / External Events
     */

    /**
     *  Called by the enabling or disabling of the pause state.
     *  @param _event Structure containing a boolean if the state has just been paused.
     */
    private function onPaused(_event : { state : Bool })
    {
        PuzzleState.cursor.mouse = None;
        
        if (_event.state)
        {
            disableHud();
            design.active = false;
            image.active  = false;
        }
        else
        {
            enableHud();
            design.active = true;
            image.active  = true;
        }
    }

    /**
     *  When called the current puzzle design and image will be turnt into a playable .puzzle
     *  @param _event - Structure containing the name and description of the puzzle.
     */
    private function onExport(_event : { name : String, description : String })
    {
        var puzzle : components.designer.PuzzleDesign = cast design.get('puzzle');
        var pixels = new snow.api.buffers.Uint8Array(puzzle.columns() * puzzle.rows() * 4);

        if (image.has('display'))
        {
            var grid : components.designer.DesignerDisplay = cast image.get('display');

            var buff = new Array<Float>();
            for (row in 0...puzzle.rows())
            {
                for (column in 0...puzzle.columns())
                {
                    var color = grid.getColor(row, column);
                    buff.push(color.r * 255);
                    buff.push(color.g * 255);
                    buff.push(color.b * 255);
                    buff.push(color.a * 255);
                }
            }
            pixels.set(buff, 0);
        }
        
        utils.storage.PuzzleStorage.save(new data.PuzzleInfo(Luxe.utils.uniquehash(), _event.name, 'author', _event.description, puzzle.active, pixels));
    }

    /**
     *  Disables the HUD
     */
    private function disableHud()
    {
        for (child in hud.children)
        {
            child.active = false;

            if (child.name == 'ui_paintsHolder')
            {
                for (paint in child.children) paint.active = false;
            }
        }
    }

    /**
     *  Enables the HUD
     */
    private function enableHud()
    {
        for (child in hud.children)
        {
            child.active = true;

            if (child.name == 'ui_paintsHolder')
            {
                for (paint in child.children) paint.active = true;
            }
        }
    }
}
