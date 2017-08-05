package data;

import data.PuzzleGrid;

class PuzzleInfo
{
    /**
     *  Name of this puzzle.
     */
    public var name : String;

    /**
     *  The completed puzzle grid.
     */
    public var grid : PuzzleGrid;

    /**
     *  Array of ints which form the 
     */
    public var pixels : Array<Int>;

    /**
     *  The author of the puzzle.
     */
    public var author : String;

    /**
     *  The puzzle description.
     */
    public var description : String;

    public function new(_name : String, _author : String, _description : String, _grid : PuzzleGrid, _pixels : Array<Int>)
    {
        name        = _name;
        author      = _author;
        description = _description;
        grid        = _grid;
        pixels      = _pixels;
    }
}
