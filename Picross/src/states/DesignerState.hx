package states;

import luxe.States;
import luxe.Parcel;
import luxe.ParcelProgress;
import luxe.Color;
import luxe.Visual;
import luxe.Input;
import game.PuzzleState;

import mint.focus.Focus;
import mint.layout.margins.Margins;
import mint.render.luxe.LuxeMintRender;
import ui.AutoCanvas;

class DesignerState extends State
{
    private var enterData : data.states.DesignerTextureSize;
    private var puzzle : Visual;

    // Mint stuff
    private var focus     : Focus;
    private var layout    : Margins;
    private var canvas    : AutoCanvas;
    private var rendering : LuxeMintRender;

    private var alphaScale : mint.Slider;

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

        // Setup mint
        rendering = new LuxeMintRender();
        layout    = new Margins();
        canvas    = new AutoCanvas({
            name : 'canvas',
            rendering : rendering,
            x : 0,
            y : 0,
            w : Luxe.screen.width  / Luxe.screen.device_pixel_ratio,
            h : Luxe.screen.height / Luxe.screen.device_pixel_ratio,
        });

        focus = new Focus(canvas);
        canvas.auto_listen();
    }

    private function assets_loaded(_parcel : Parcel)
    {
        PuzzleState.init();

        trace(enterData.width, enterData.height);

        puzzle = new Visual({ name : 'design' });
        puzzle.add(new components.designer.PuzzleDesigner({ name : 'puzzle', width : enterData.width, height : enterData.height }));
        puzzle.add(new components.Dimensions({ name : 'dimensions' }));
        puzzle.add(new components.Display   ({ name : 'display'    }));
        puzzle.add(new components.designer.DesignerMouse({ name : 'mouse' }));

        if (enterData.texture != null) puzzle.add(new components.designer.Overlay({ name : 'overlay', texture : enterData.texture }));

        // Create main UI
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
    }
}
