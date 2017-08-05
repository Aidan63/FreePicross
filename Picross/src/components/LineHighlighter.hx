package components;

import luxe.Component;
import luxe.Vector;
import entities.FxLineHighlighter;
import components.Dimensions;
import components.Display;
import data.events.CellPosition;
import utils.PuzzleHelper;

class LineHighlighter extends Component
{
    override public function onadded()
    {
        entity.events.listen('cell.brushed', onCellChanged);
        entity.events.listen('cell.removed', onCellChanged);
    }

    override public function onremoved()
    {
        entity.events.unlisten('cell.brushed');
        entity.events.unlisten('cell.removed');
    }

    /**
     *  Called when a cell is removed or brushed.
     *  Checks if the row or column in the cell position has been completed.
     *  If so create row / column completed effects.
     *  
     *  @param _position The position of the modified cell.
     */
    private function onCellChanged(_position : CellPosition)
    {
        if (has('puzzle'))
        {
            if (PuzzleHelper.rowCompleted(_position.row, cast get('puzzle')))
            {
                // Create a line complete visual for the row.
                createRowHighlighter(_position);
            }

            if (PuzzleHelper.columnCompleted(_position.column, cast get('puzzle')))
            {
                // Create a line complete visual for the column
                createColumnHighlighter(_position);
            }
        }
    }

    private function createRowHighlighter(_position : CellPosition)
    {
        if (has('dimensions') && has('display'))
        {
            var parent     : luxe.Visual = cast entity;
            var dimensions : Dimensions  = cast get('dimensions');
            var display    : Display     = cast get('display');
            var displayPos : Vector      = display.data.display.pos.clone().subtract(display.data.display.origin);

            new FxLineHighlighter(Horizontal, displayPos.x, displayPos.y + (dimensions.cellSize * _position.row), parent.size.x, dimensions.cellSize);

            /*
            var leftGradient = new Visual({
                depth : 2,
                geometry : Luxe.draw.box({
                    x : displayPos.x - (size.cellSize * 1.5),
                    y : displayPos.y + (size.cellSize * _position.row),
                    w : size.cellSize * 1.5,
                    h : size.cellSize
                })
            });
            leftGradient.add(new components.Gradient(new Color(1, 1, 1, 0), new Color(1, 1, 1, 1), Horizontal, 2));
            leftGradient.add(new components.AlphaFade({ name : 'fade_in' , time : 0.2, startAlpha : 0, endAlpha : 1 }));
            //leftGradient.add(new components.AlphaFade({ name : 'fade_out', time : 0.4, startAlpha : 1, endAlpha : 0 , delay : 0.2 }));
            leftGradient.add(new components.DestroyTimer({ name : 'destroy', delay : 0.6 }));

            var rowBody = new Visual({
                depth : 2,
                color : new Color(1, 1, 1, 1),
                geometry : Luxe.draw.box({
                    x : displayPos.x,
                    y : displayPos.y + (size.cellSize * _position.row),
                    w : size.width,
                    h : size.cellSize
                })
            });
            rowBody.add(new components.AlphaFade({ name : 'fade_in' , time : 0.2, startAlpha : 0, endAlpha : 1 }));
            //rowBody.add(new components.AlphaFade({ name : 'fade_out', time : 0.4, delay : 0.2, startAlpha : 1, endAlpha : 0 }));
            rowBody.add(new components.DestroyTimer({ name : 'destroy', delay : 0.6 }));

            var rightGradient = new Visual({
                depth : 2,
                geometry : Luxe.draw.box({
                    x : displayPos.x + size.width,
                    y : displayPos.y + (size.cellSize * _position.row),
                    w : size.cellSize * 1.5,
                    h : size.cellSize
                })
            });
            rightGradient.add(new components.Gradient(new Color(1, 1, 1, 1), new Color(1, 1, 1, 0), Horizontal, 1));
            rightGradient.add(new components.AlphaFade({ name : 'fade_in' , time : 0.2, startAlpha : 0, endAlpha : 1 }));
            //rightGradient.add(new components.AlphaFade({ name : 'fade_out', time : 0.4, startAlpha : 1, endAlpha : 0 , delay : 0.2 }));
            rightGradient.add(new components.DestroyTimer({ name : 'destroy', delay : 0.6 }));
            */
        }
    }

    private function createColumnHighlighter(_position : CellPosition)
    {
        if (has('dimensions') && has('display'))
        {
            var parent     : luxe.Visual = cast entity;
            var dimensions : Dimensions  = cast get('dimensions');
            var display    : Display     = cast get('display');
            var displayPos : Vector      = display.data.display.pos.clone().subtract(display.data.display.origin);

            new FxLineHighlighter(Vertical, displayPos.x + (dimensions.cellSize * _position.column), displayPos.y, dimensions.cellSize, parent.size.y);
        }
    }
}
