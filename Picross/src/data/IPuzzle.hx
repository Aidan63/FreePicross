package data;

interface IPuzzle
{
    public var active : data.PuzzleGrid;
    public function rows() : Int;
    public function columns() : Int;
}
