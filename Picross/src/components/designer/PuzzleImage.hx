package components.designer;

import luxe.Component;
import luxe.options.ComponentOptions;
import data.IPuzzle;
import data.PuzzleGrid;
import data.events.CellPosition;
import game.PuzzleState;

class PuzzleImage extends Component implements IPuzzle
{
    public var active : PuzzleGrid;
    private var width : Int;
    private var height : Int;

    public function new(_options : PuzzleImageOptions)
    {
        super(_options);
        width = _options.width;
        height = _options.height;
    }

    override public function onadded()
    {
        active = new PuzzleGrid(width, height);

        entity.events.listen('cell.selected', onCellSelected);
    }

    override public function onremoved()
    {
        entity.events.unlisten('cell.selected');
    }

    public function rows() : Int
    {
        return width;
    }

    public function columns() : Int
    {
        return height;
    }

    private function onCellSelected(_position : CellPosition)
    {
        switch (PuzzleState.cursor.mouse)
        {
            case Brush: brushCell(_position);
            case Rubber: removeCell(_position);
            default:
        }
    }

    private function brushCell(_position : CellPosition)
    {
        var cell = active.data[_position.row][_position.column];
        cell.state = Brushed;
        cell.color = PuzzleState.color.currentColor;

        entity.events.fire('cell.brushed', _position);
    }

    private function removeCell(_position : CellPosition)
    {
        var cell = active.data[_position.row][_position.column];
        cell.state = Destroyed;

        entity.events.fire('cell.removed', _position);
    }
}

typedef PuzzleImageOptions = {
    > ComponentOptions,
    var width : Int;
    var height : Int;
}
