package components;

import luxe.Component;
import luxe.Vector;
import luxe.Color;
import luxe.Visual;
import data.events.CellPosition;

class CellHighlighter extends Component
{
    private var visual : Visual;

    override public function onadded()
    {
        entity.events.listen('cell.brushed', onCellBrushed);
        entity.events.listen('cell.removed', onCellBrushed);

        visual = cast entity;
    }

    override public function onremoved()
    {
        entity.events.unlisten('cell.brushed');
        entity.events.unlisten('cell.removed');
    }

    private function onCellBrushed(_position : CellPosition)
    {
        if (has('dimensions'))
        {
            var size : Dimensions = cast get('dimensions');
            var cellPos : Vector = visual.pos.clone()
                                             .subtract(visual.origin)
                                             .add_xyz(_position.column * size.cellSize, _position.row * size.cellSize)
                                             .add_xyz(size.cellSize / 2, size.cellSize / 2);
            
            var ent = new luxe.Visual({
                pos     : cellPos,
                depth   : 2,
                origin  : new Vector(size.cellSize / 2, size.cellSize / 2),
                size    : new Vector(size.cellSize, size.cellSize),
                color   : new Color(1, 1, 1, 1)
            });

            ent.add(new components.AlphaFade({ name : 'fade_in' , time : 0.1, startAlpha : 0, endAlpha : 1 }));
            ent.add(new components.AlphaFade({ name : 'fade_out', time : 0.2, delay : 0.1, startAlpha : 1, endAlpha : 0 }));
            ent.add(new components.Scale({ name : 'scale', time : 0.1, factor : 1.1 }));
            ent.add(new components.DestroyTimer({ name : 'destroy', delay : 0.4 }));
        }
    }
}
