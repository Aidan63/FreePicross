package components;

import luxe.Component;
import luxe.Vector;
import luxe.Visual;
import data.events.CellPosition;

class Faults extends Component
{
    private var visual : Visual;

    override public function onadded()
    {
        entity.events.listen('cell.fault', onCellFault);

        visual = cast entity;
    }

    override public function onremoved()
    {
        entity.events.unlisten('cell.fault');
    }

    /**
     *  When a cell fault occurs create the cross and flicker effect.
     *  @param _position The cell position the fault occured in.
     */
    private function onCellFault(_position : CellPosition)
    {
        if (has('dimensions'))
        {
            var size : Dimensions = cast get('dimensions');

            var cellPos : Vector = visual.pos.clone()
                                             .subtract(visual.origin)
                                             .add_xyz(_position.column * size.cellSize, _position.row * size.cellSize);
            createFaultCross(cellPos, size.cellSize);
            createCellFlicker(cellPos, size.cellSize);            
        }
    }

    private function createFaultCross(_position : Vector, _cellSize : Float)
    {
        var ent = new luxe.Visual({
            pos : _position,
            size : new Vector(_cellSize, _cellSize),
            texture : Luxe.resources.texture('assets/images/fault.png'),
            depth : 2
        });

        ent.add(new components.Flicker({ name : 'flicker', delay : 0.25, interval : 0.5 }));
        ent.add(new components.Slider({ name : 'slider', end : ent.pos.clone().subtract_xyz(0, _cellSize), time : 0.25 }));
        ent.add(new components.DestroyTimer({ name : 'destroy', delay : 3 }));
    }

    private function createCellFlicker(_position : Vector, _cellSize : Float)
    {
        var ent = new luxe.Visual({
            depth    : 2,
            color    : new luxe.Color().set(1, 0, 0, 1),
            geometry : Luxe.draw.box({
                x : _position.x,
                y : _position.y,
                w : _cellSize,
                h : _cellSize
            })
        });

        ent.add(new components.Flicker({ name : 'flicker', delay : 0, interval : 0.5, alpha1 : 0.5 }));
        ent.add(new components.DestroyTimer({ name : 'destroy', delay : 2.9 }));
    }
}
