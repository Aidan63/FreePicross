package states;

import luxe.States;
import luxe.Parcel;
import luxe.ParcelProgress;
import luxe.Color;
import luxe.Visual;
import game.PuzzleState;
import ui.designer.DesignerUI;

using utils.EntityHelper;

class DesignerState extends State
{
    private var enterData : data.states.DesignerTextureSize;
    private var puzzle : Visual;

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
                { id : 'assets/images/ui/paintSelector.png' }
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

        /**
        puzzle = new Visual({ name : 'design' });
        puzzle.add(new components.designer.PuzzleDesigner({ name : 'puzzle', width : enterData.width, height : enterData.height }));
        puzzle.add(new components.Dimensions({ name : 'dimensions' }));
        puzzle.add(new components.Display   ({ name : 'display'    }));
        puzzle.add(new components.designer.DesignerMouse({ name : 'mouse' }));

        if (enterData.texture != null) puzzle.add(new components.designer.Overlay({ name : 'overlay', texture : enterData.texture }));
        */

        PuzzleState.ui.newHud = DesignerUI.create();
        PuzzleState.ui.newHud.findChild('ui_export').events.listen('clicked', onExportClicked);
        PuzzleState.ui.newHud.findChild('ui_paintPrimary').events.listen('clicked', onPaintPrimaryClicked);
        PuzzleState.ui.newHud.findChild('ui_paintSecondary').events.listen('clicked', onPaintSecondaryClicked);

        var paintsHolder = PuzzleState.ui.newHud.findChild('ui_paintsHolder');
        for (i in 0...DesignerUI.paints.length)
        {
            paintsHolder.findChild('ui_paint$i').events.listen('clicked', onPaintClicked.bind(_, i));
        }

        // Create main UI
        /*
        new ui.designer.DesignerUI(puzzle);

        // Create some temp mint UI elements
        alphaScale = new mint.Slider({
            parent : canvas,
            name : 'alpha_slider',
            x : 16, y : 432, w : 96, h : 32,
            min : 0, max : 100, step : 1, vertical : false, value : 50
        });
        alphaScale.onchange.listen(function(_val, _) {
            if (puzzle != null && puzzle.has('overlay'))
            {
                var overlay : components.designer.Overlay = cast puzzle.get('overlay');
                overlay.visual.color.a = _val / 100;
            }
        });
        */
    }

    private function onExportClicked(_)
    {
        trace('Export Clicked');
    }

    private function onPaintPrimaryClicked(_)
    {
        trace('primary paint');
    }

    private function onPaintSecondaryClicked(_)
    {
        trace('secondary paint');
    }

    private function onPaintClicked(_, _paintNumber : Int)
    {
        trace('Paint $_paintNumber');
    }
}
