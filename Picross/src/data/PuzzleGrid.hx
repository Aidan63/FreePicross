package data;

import game.ColorSelector;

class PuzzleGrid
{
    /**
     *  2D array of the puzzle grid.
     */
    public var data : Array<Array<PuzzleCell>>;

    public function new(_rows : Int, _columns : Int)
    {
        data = [ for (row in 0..._rows) [ for (column in 0..._columns) new PuzzleCell(row, column) ] ];
    }
}

class PuzzleCell
{
    /**
     *  The row this cell is in.
     */
    public var row : Int;

    /**
     *  The column this cell is it.
     */
    public var column : Int;

    /**
     *  The colour of this cell.
     */
    public var color : ColorTypes;

    /**
     *  The state of this cell.
     */
    public var state : CellState;

    public function new(_row : Int, _column : Int)
    {
        row = _row;
        column = _column;
        color = ColorTypes.Primary;
        state = CellState.Empty;
    }
}

enum CellState {
    Destroyed;
    Empty;
    Penciled;
    Brushed;
}
