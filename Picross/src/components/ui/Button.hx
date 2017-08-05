package components.ui;

import luxe.Component;
import luxe.Input;
import luxe.Visual;
import luxe.Vector;

class Button extends Component
{
    private var visual : Visual;

    override public function onadded()
    {
        visual = cast entity;
    }

    override public function onmousedown(_event : MouseEvent)
    {
        var mouse : Vector = Luxe.camera.screen_point_to_world(_event.pos);
        if (Luxe.utils.geometry.point_in_geometry(mouse, visual.geometry))
        {
            entity.events.fire('clicked');
        }
    }
}
