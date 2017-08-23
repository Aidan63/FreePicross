package components.ui;

import luxe.Component;
import luxe.NineSlice;
import luxe.Input;
import luxe.Color;
import luxe.Rectangle;
import luxe.Log.def;
using utils.EntityHelper;

@:enum abstract ButtonState(Int) from Int to Int {
    var None    = 0;
    var Hover   = 1;
    var Clicked = 2;
}

class NineSliceButton extends Component
{
    private var visual : NineSlice;

    private var uvs : Array<Rectangle>;
    private var colors : Array<Color>;
    private var state : ButtonState;

    public function new(_options : NineSliceButtonOptions)
    {
        super(_options);

        colors = def(_options.colors, [ new Color(), new Color(), new Color() ]);
        uvs = _options.uvs;
    }

    override public function onadded()
    {
        visual = cast entity;
        visual.transform.world.auto_decompose = true;

        state = None;
        setOptions();
        visual.create(pos, visual.size.x, visual.size.y, true);
    }

    override public function onmousemove(_event : MouseEvent)
    {
        var mouse = Luxe.camera.screen_point_to_world(_event.pos);
        if (mouse.pointInside(visual.transform.world.pos, visual.size))
        {
            if (state == Clicked || state == Hover) return;
            
            state = Hover;
            setOptions();
            visual.create(pos, visual.size.x, visual.size.y, true);
            visual.events.fire('over');
        }
        else
        {
            if (state == None) return;
            
            state = None;
            setOptions();
            visual.create(pos, visual.size.x, visual.size.y, true);
            visual.events.fire('out');
        }
    }

    override public function onmousedown(_event : MouseEvent)
    {
        var mouse = Luxe.camera.screen_point_to_world(_event.pos);
        if (mouse.pointInside(visual.transform.world.pos, visual.size))
        {
            state = Clicked;
            setOptions();
            visual.create(pos, visual.size.x, visual.size.y, true);
            visual.events.fire('clicked');
        }
    }

    override public function onmouseup(_event : MouseEvent)
    {
        if (state != Clicked) return;

        var mouse = Luxe.camera.screen_point_to_world(_event.pos);
        if (mouse.pointInside(visual.transform.world.pos, visual.size))
        {
            state = Hover;
        }
        else
        {
            state = None;
        }

        setOptions();
        visual.create(pos, visual.size.x, visual.size.y, true);
        visual.events.fire('released', { state : state });
    }

    private function setOptions()
    {
        visual.source_x = uvs[state].x;
        visual.source_y = uvs[state].y;
        visual.source_w = uvs[state].w;
        visual.source_h = uvs[state].h;
        visual.color = colors[state];
    }
}

typedef NineSliceButtonOptions = {
    var name : String;
    var uvs : Array<Rectangle>;
    @:optional var colors : Array<Color>;
}
