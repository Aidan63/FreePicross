package data.events;

class PuzzleSize
{
    /**
     *  The width of the puzzle.
     */
    public var rows : Int;

    /**
     *  The height of the puzzle.
     */
    public var columns : Int;

    public function new(_rows : Int, _columns : Int)
    {
        rows = _rows;
        columns = _columns;
    }
}
