package components.ui;

import luxe.Component;
import luxe.NineSlice;
import luxe.Input;
import luxe.Vector;

enum ButtonState {
    None;
    Hover;
    Clicked;
}

class NineSliceSwitcher extends Component
{
    private var button : NineSlice;
    private var state : ButtonState;
    private var verts : Array<Vector>;

    override public function onadded()
    {
        button = cast entity;
        state  = None;
        verts  = [ new Vector(0, 0), new Vector(button.width, 0), new Vector(button.width, button.height), new Vector(0, button.height) ];
    }

    override public function onmousemove(_event : MouseEvent)
    {
        if (state == Clicked) return;

        var mouse : Vector = Luxe.camera.screen_point_to_world(_event.pos);
        if (Luxe.utils.geometry.point_in_polygon(mouse, button.pos.clone().add(button.parent.pos), verts))
        {
            if (state != Hover)
            {
                button.source_x = 80;
                button.source_y = 0;
                button.create(button.pos, button.width, button.height, true);
                state = Hover;
            }
        }
        else
        {
            if (state != None)
            {
                button.source_x = 0;
                button.source_y = 0;
                button.create(button.pos, button.width, button.height, true);
                state = None;
            }
        }
    }

    override public function onmousedown(_event : MouseEvent)
    {
        var mouse : Vector = Luxe.camera.screen_point_to_world(_event.pos);
        if (Luxe.utils.geometry.point_in_polygon(mouse, button.pos.clone().add(button.parent.pos), verts))
        {
            button.source_x = 160;
            button.source_y = 0;
            button.create(button.pos, button.width, button.height, true);
            state = Clicked;

            entity.events.fire('clicked');
        }
    }

    override public function onmouseup(_event : MouseEvent)
    {
        button.source_x = 0;
        button.source_y = 0;
        button.create(button.pos, button.width, button.height, true);
        state = None;
    }
}
