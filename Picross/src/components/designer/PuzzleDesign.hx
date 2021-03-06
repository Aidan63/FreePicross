package components.designer;

import luxe.Component;
import luxe.options.ComponentOptions;
import data.PuzzleGrid;
import data.IPuzzle;
import data.events.CellPosition;
import game.PuzzleState;

class PuzzleDesign extends Component implements IPuzzle
{
    public var active : PuzzleGrid;
    private var _rows : Int;
    private var _columns : Int;

    public function new(_options : PuzzleDesignOptions)
    {
        super(_options);
        _rows = _options.rows;
        _columns = _options.columns;
    }

    override public function onadded()
    {
        active = new PuzzleGrid(_rows, _columns);

        // Loop over the grid and set all cells to destroyed.
        for (row in active.data)
        {
            for (cell in row)
            {
                cell.state = Destroyed;
            }
        }

        entity.events.listen('cell.brushed' , onCellBrushed);
        entity.events.listen('cell.removed' , onCellRemoved);
        entity.events.listen('cell.selected', onCellSelected);
    }

    override public function onremoved()
    {
        entity.events.unlisten('cell.brushed');
        entity.events.unlisten('cell.removed');
        entity.events.unlisten('cell.selected');
    }

    public function rows() : Int
    {
        return _rows;
    }

    public function columns() : Int
    {
        return _columns;
    }

    private function onCellBrushed(_position : CellPosition)
    {
        var cell = active.data[_position.row][_position.column];

        cell.state = Brushed;
        cell.color = PuzzleState.color.currentColor;
    }
    private function onCellRemoved(_position : CellPosition)
    {
        var cell = active.data[_position.row][_position.column];
        cell.state = Destroyed;
    }
    private function onCellSelected(_position : CellPosition)
    {
        if (PuzzleState.cursor.mouse != Brush) return;

        if (active.data[_position.row][_position.column].state == Brushed)
        {
            entity.events.fire('cell.brushed', _position);
        }
    }
}

typedef PuzzleDesignOptions = {
    > ComponentOptions,
    var rows : Int;
    var columns : Int;
}
