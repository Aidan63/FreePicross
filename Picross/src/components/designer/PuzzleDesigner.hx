package components.designer;

import luxe.Component;
import luxe.options.ComponentOptions;
import data.IPuzzle;
import data.PuzzleGrid;
import data.events.CellPosition;
import game.PuzzleState;

class PuzzleDesigner extends Component implements IPuzzle
{
    public var grid : PuzzleGrid;
    private var width : Int;
    private var height : Int;

    public function new(_options : PuzzleDesignerOptions)
    {
        super(_options);
        width = _options.width;
        height = _options.height;
    }

    override public function onadded()
    {
        grid = new PuzzleGrid(width, height);

        entity.events.listen('cell.selected', onCellSelected);
    }

    override public function onremoved()
    {
        entity.events.unlisten('cell.selected');
    }

    public function rows() : Int
    {
        return grid.data.length;
    }

    public function columns() : Int
    {
        return grid.data[0].length;
    }

    private function onCellSelected(_position : CellPosition)
    {
        switch (PuzzleState.cursor.mouse)
        {
            case Brush: brushCell(_position);
            case Clean: cleanCell(_position);
            default:
        }
    }

    private function brushCell(_position : CellPosition)
    {
        var cell = grid.data[_position.row][_position.column];
        cell.state = Brushed;
        cell.color = PuzzleState.color.currentColor;

        entity.events.fire('cell.brushed', _position);
    }

    private function cleanCell(_position : CellPosition)
    {
        var cell = grid.data[_position.row][_position.column];
        cell.state = Empty;

        entity.events.fire('cell.clean', _position);
    }
}

typedef PuzzleDesignerOptions = {
    > ComponentOptions,
    var width : Int;
    var height : Int;
}
