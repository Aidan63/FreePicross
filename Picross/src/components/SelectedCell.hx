package components;

import luxe.Component;
import luxe.Visual;
import luxe.Input;
import luxe.Color;
import luxe.Vector;

class SelectedCell extends Component
{
    private var visual : Visual;
    private var highlighter : Visual;

    override public function onadded()
    {
        visual = cast entity;
    }

    override public function onremoved()
    {
        if (highlighter != null) highlighter.destroy();
    }

    override public function onmousemove(_event : MouseEvent)
    {
        if (has('dimensions'))
        {
            var dimensions : Dimensions = cast get('dimensions');
            var mouse : Vector = Luxe.camera.screen_point_to_world(_event.pos);

            if (Luxe.utils.geometry.point_in_geometry(mouse, visual.geometry))
            {
                if (highlighter == null)
                {
                    highlighter = new Visual({
                        size  : new Vector(dimensions.cellSize, dimensions.cellSize),
                        color : new Color(1, 1, 1, 0.5),
                        depth : 3
                    });
                }

                var mouseDisplayPos : Vector = mouse.clone().subtract(visual.pos);
                highlighter.pos.set_xy(visual.pos.x + Math.floor(mouseDisplayPos.x / dimensions.cellSize) * dimensions.cellSize,
                                       visual.pos.y + Math.floor(mouseDisplayPos.y / dimensions.cellSize) * dimensions.cellSize);
            }
            else
            {
                if (highlighter != null)
                {
                    highlighter.destroy();
                    highlighter = null;
                }
            }
        }
    }
}
