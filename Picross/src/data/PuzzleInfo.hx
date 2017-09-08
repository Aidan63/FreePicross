package data;

import haxe.io.Bytes;
import data.PuzzleGrid;

class PuzzleInfo
{
    /**
     *  The unique ID for this puzzle.
     */
    public var id : Int;

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
    public var pixels : Bytes;

    /**
     *  The author of the puzzle.
     */
    public var author : String;

    /**
     *  The puzzle description.
     */
    public var description : String;

    public function new(_id : Int, _name : String, _author : String, _description : String, _grid : PuzzleGrid, _pixels : Bytes)
    {
        id          = _id;
        name        = _name;
        author      = _author;
        description = _description;
        grid        = _grid;
        pixels      = _pixels;
    }
}
