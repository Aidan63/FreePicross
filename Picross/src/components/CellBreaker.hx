package components;

import luxe.Component;
import luxe.Vector;
import luxe.Visual;
import luxe.Color;
import components.Dimensions;
import data.events.CellPosition;

class CellBreaker extends Component
{
    private var visual : Visual;

    override public function onadded()
    {
        entity.events.listen('cell.removed', onCellRemoved);
        visual = cast entity;
    }

    override public function onremoved()
    {
        entity.events.unlisten('cell.removed');
    }

    private function onCellRemoved(_position : CellPosition)
    {
        if (has('dimensions'))
        {
            var size : Dimensions = cast get('dimensions');

            var cellPos : Vector = visual.pos.clone()
                                             .subtract(visual.origin)
                                             .add_xyz(_position.column * size.cellSize, _position.row * size.cellSize);
            var quarterSize : Float = size.cellSize / 4;

            var fragTL = new luxe.Visual({
                pos     : cellPos.clone().add_xyz(quarterSize, quarterSize),
                depth   : 2,
                origin  : new Vector(quarterSize, quarterSize),
                size    : new Vector(size.cellSize / 2, size.cellSize / 2),
                texture : Luxe.resources.texture('assets/images/cellFragment.png'),
                color   : new Color().rgb(0x666666),
                scale   : new Vector(1, 1)
            });
            fragTL.add(new components.Gravity({ name : 'gravity', value : 600, ix : -40, iy : -200 }));
            fragTL.add(new components.Rotate({ name : 'rotate', speed : -50 }));
            fragTL.add(new components.DestroyTimer({ name : 'destroy', delay : 0.5 }));

            var fragTR = new luxe.Visual({
                pos     : cellPos.clone().add_xyz(quarterSize * 3, quarterSize),
                depth   : 2,
                origin  : new Vector(quarterSize, quarterSize),
                size    : new Vector(size.cellSize / 2, size.cellSize / 2),
                texture : Luxe.resources.texture('assets/images/cellFragment.png'),
                color   : new Color().rgb(0x666666),
                scale   : new Vector(-1, 1)
            });
            fragTR.add(new components.Gravity({ name : 'gravity', value : 600, ix : 40, iy : -200 }));
            fragTR.add(new components.Rotate({ name : 'rotate', speed : 50 }));
            fragTR.add(new components.DestroyTimer({ name : 'destroy', delay : 0.5 }));

            var fragBL = new luxe.Visual({
                pos     : cellPos.clone().add_xyz(quarterSize, quarterSize * 3),
                depth   : 2,
                origin  : new Vector(quarterSize, quarterSize),
                size    : new Vector(size.cellSize / 2, size.cellSize / 2),
                texture : Luxe.resources.texture('assets/images/cellFragment.png'),
                color   : new Color().rgb(0x666666),
                scale   : new Vector(1, -1)
            });
            fragBL.add(new components.Gravity({ name : 'gravity', value : 600, ix : -40, iy : -100 }));
            fragBL.add(new components.Rotate({ name : 'rotate', speed : -50 }));
            fragBL.add(new components.DestroyTimer({ name : 'destroy', delay : 0.5 }));

            var fragBR = new luxe.Visual({
                pos     : cellPos.clone().add_xyz(quarterSize * 3, quarterSize * 3),
                depth   : 2,
                origin  : new Vector(quarterSize, quarterSize),
                size    : new Vector(size.cellSize / 2, size.cellSize / 2),
                texture : Luxe.resources.texture('assets/images/cellFragment.png'),
                color   : new Color().rgb(0x666666),
                scale   : new Vector(-1, -1)
            });
            fragBR.add(new components.Gravity({ name : 'gravity', value : 600, ix : 40, iy : -100 }));
            fragBR.add(new components.Rotate({ name : 'rotate', speed : 50 }));
            fragBR.add(new components.DestroyTimer({ name : 'destroy', delay : 0.5 }));
        }
    }
}
