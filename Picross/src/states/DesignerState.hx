package states;

import luxe.States;
import luxe.Parcel;
import luxe.ParcelProgress;
import luxe.Color;
import luxe.Visual;
import luxe.Vector;
import game.PuzzleState;
import ui.designer.DesignerUI;

using utils.EntityHelper;

class DesignerState extends State
{
    private var enterData : data.states.DesignerTextureSize;

    private var puzzle : Visual;
    private var design : Visual;

    override public function onenter<T>(_data : T)
    {
        enterData = cast _data;

        var parcel = new Parcel({
            textures : [
                { id : 'assets/images/cells.png' },
                { id : 'assets/images/cellFragment.png' },
                { id : 'assets/images/fault.png' },
                { id : 'assets/images/RuleCircle.png' },
                { id : 'assets/images/RuleSquare.png' },
                { id : 'assets/images/ui/paintSelector.png' },
                { id : 'assets/images/ui/buttonExport.png' }
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

    private function assets_loaded(_parcel : Parcel)
    {
        PuzzleState.init();

        // Create an entity for the actual puzzle cells.
        puzzle = new Visual({ name : 'puzzle' });
        puzzle.add(new components.designer.PuzzleDesigner({ name : 'puzzle', width : 8, height : 8 }));
        puzzle.add(new components.Dimensions({ name : 'dimensions' }));
        puzzle.add(new components.Display   ({ name : 'display', boundary : new Vector(496, 400) }));
        puzzle.add(new components.designer.DesignerMouse({ name : 'mouse' }));
        puzzle.pos.set_xy(344, 296);
        Luxe.draw.rectangle({
            x : puzzle.pos.x - puzzle.origin.x,
            y : puzzle.pos.y - puzzle.origin.y,
            w : puzzle.size.x,
            h : puzzle.size.y,
            color : new Color(0, 0, 0, 0.25)
        });

        // Create an entity for the finished puzzle image.
        design = new Visual({ name : 'design', pos : new Vector(688, 96) });
        design.add(new components.designer.PuzzleDesigner({ name : 'grid', width : 8, height : 8 }));
        design.add(new components.Dimensions({ name : 'dimensions' }));
        design.add(new components.designer.DesignerDisplay({ name : 'display', boundary : new Vector(496, 400) }));
        design.add(new components.designer.DesignerMouse({ name : 'mouse' }));
        design.add(new components.SelectedCell({ name : 'cell_selector' }));
        Luxe.draw.rectangle({ x : design.pos.x, y : design.pos.y, w : design.size.x, h : design.size.y, color : new Color(0, 0, 0, 0.25) });

        // Create the HUD and link up event listeners.
        PuzzleState.ui.newHud = DesignerUI.create();
        PuzzleState.ui.newHud.findChild('ui_export').events.listen('clicked', onExportClicked);
        PuzzleState.ui.newHud.findChild('ui_paintPrimary').events.listen('clicked', onPaintPrimaryClicked);
        PuzzleState.ui.newHud.findChild('ui_paintSecondary').events.listen('clicked', onPaintSecondaryClicked);

        var paintsHolder = PuzzleState.ui.newHud.findChild('ui_paintsHolder');
        for (i in 0...DesignerUI.paints.length)
        {
            paintsHolder.findChild('ui_paint$i').events.listen('clicked', onPaintClicked.bind(_, i));
        }
    }

    /**
     *  When export is clicked the HUD is disable and a popup is shown with save and export options.
     */
    private function onExportClicked(_)
    {
        trace('Export Clicked');
        PuzzleState.ui.disableHud();
    }

    /**
     *  When the primary paint is selected we set the puzzle state paint to primary and show some click effects.
     */
    private function onPaintPrimaryClicked(_)
    {
        var button   : Visual = cast PuzzleState.ui.newHud.findChild('ui_paintPrimary');
        var selector : Visual = cast PuzzleState.ui.newHud.findChild('ui_puzzlePaintSelector');

        PuzzleState.color.currentColor = Primary;

        if (selector.has('slide')) selector.remove('slide');
        selector.add(new components.Slider({ name : 'slide', time : 0.25, end : button.pos, ease : luxe.tween.easing.Quad.easeInOut }));

        utils.Effect.select(button.pos.clone(), button.size.clone(), new Vector(8, 8), PuzzleState.ui.newHud);
    }

    /**
     *  When the secondary paint is selected we set the puzzle state paint to secondary and show some click effects.
     */
    private function onPaintSecondaryClicked(_)
    {
        var button   : Visual = cast PuzzleState.ui.newHud.findChild('ui_paintSecondary');
        var selector : Visual = cast PuzzleState.ui.newHud.findChild('ui_puzzlePaintSelector');

        PuzzleState.color.currentColor = Secondary;

        if (selector.has('slide')) selector.remove('slide');
        selector.add(new components.Slider({ name : 'slide', time : 0.25, end : button.pos, ease : luxe.tween.easing.Quad.easeInOut }));

        utils.Effect.select(button.pos.clone(), button.size.clone(), new Vector(8, 8), PuzzleState.ui.newHud);
    }

    /**
     *  Set the designer paint ID to that of the pressed paint button and show some click effects.
     *  @param _paintNumber The number ID of the paint clicked.
     */
    private function onPaintClicked(_, _paintNumber : Int)
    {
        var paint    : Visual = cast PuzzleState.ui.newHud.findChild('ui_paintsHolder').findChild('ui_paint$_paintNumber');
        var selector : Visual = cast PuzzleState.ui.newHud.findChild('ui_paintsHolder').findChild('ui_designerPaintSelector');

        if (selector.has('slide')) selector.remove('slide');
        selector.add(new components.Slider({ name : 'slide', time : 0.25, end : paint.pos, ease : luxe.tween.easing.Quad.easeInOut }));

        utils.Effect.select(paint.pos.clone(), paint.size.clone(), new Vector(4, 4), PuzzleState.ui.newHud.findChild('ui_paintsHolder'));
    }
}
