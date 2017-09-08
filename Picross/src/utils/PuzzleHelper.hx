package utils;

import haxe.io.Bytes;
import luxe.Visual;
import components.Puzzle;
import data.PuzzleGrid;
import game.ColorSelector;

/**
 *  Contains useful functions which multiple components might want to access.
 */
class PuzzleHelper
{
    /**
     *  Returns if one of the rows in the provided puzzle has been completed.
     *  @param _row The row to check.
     *  @param _puzzle The puzzle.
     *  @return Bool
     */
    public static function rowCompleted(_row : Int, _puzzle : Puzzle) : Bool
    {
        for (column in 0..._puzzle.columns())
        {
            var actual   = _puzzle.active   .data[_row][column];
            var expected = _puzzle.completed.data[_row][column];

            // Destroyed cells don't care about colour, so only check if they're destoyed.
            if (expected.state == Destroyed && actual.state == Destroyed) continue;

            if (actual.color != expected.color || actual.state != expected.state)
            {
                return false;
            }
        }

        return true;
    }

    /**
     *  Returns if one of the columns in the provided puzzle has been completed.
     *  @param _column The column to check.
     *  @param _puzzle The puzzle.
     *  @return Bool
     */
    public static function columnCompleted(_column : Int, _puzzle : Puzzle) : Bool
    {
        // Check for any rows which are now complete.
        for (row in 0..._puzzle.rows())
        {
            var actual   = _puzzle.active   .data[row][_column];
            var expected = _puzzle.completed.data[row][_column];

            if (actual.color != expected.color || actual.state != expected.state)
            {
                return false;
            }
        }

        return true;
    }

    /**
     *  Returns a column from the completed puzzle grid as an array.
     *  @param _puzzle The puzzle to get the column from.
     *  @param _column The column to fetch.
     *  @return Array<PuzzleCell>
     */
    public static function columnAsArray(_puzzle : Puzzle, _column : Int) : Array<PuzzleCell>
    {
        var cells = new Array<PuzzleCell>();
        for (row in 0..._puzzle.rows())
        {
            cells.push(_puzzle.completed.data[row][_column]);
        }

        return cells;
    }

    /**
     *  Returns if a row of a certain colour in the provided puzzle has been completed.
     *  @param _puzzle The puzzle to check.
     *  @param _color the colour we are checking.
     *  @param _row The row to check.
     *  @return Bool
     */
    public static function rowCellColorCompleted(_puzzle : Puzzle, _color : ColorTypes, _row : Int) : Bool
    {
        for (column in 0..._puzzle.columns())
        {
            var actual   = _puzzle.active   .data[_row][column];
            var expected = _puzzle.completed.data[_row][column];

            if (expected.color != _color || expected.state != Brushed) continue;

            if (actual.color != expected.color || actual.state != Brushed)
            {
                return false;
            }
        }

        return true;
    }

    /**
     *  Returns if a column of a certain colour in the provided puzzle has been completed.
     *  @param _puzzle The puzzle to check.
     *  @param _color The colour we are checking.
     *  @param _column The coloumn to check.
     *  @return Bool
     */
    public static function columnCellColorComplete(_puzzle : Puzzle, _color : ColorTypes, _column : Int) : Bool
    {
        for (row in 0..._puzzle.rows())
        {
            var actual   = _puzzle.active   .data[row][_column];
            var expected = _puzzle.completed.data[row][_column];

            if (expected.color != _color || expected.state != Brushed) continue;

            if (actual.color != expected.color || actual.state != Brushed)
            {
                return false;
            }
        }

        return true;
    }

    /**
     *  Returns if the puzzle has been completed.
     *  @param _puzzle The puzzle to check.
     *  @return Bool
     */
    public static function puzzleComplete(_puzzle : Puzzle) : Bool
    {
        for (row in 0..._puzzle.rows())
        {
            if (!rowCompleted(row, _puzzle))
            {
                return false;
            }
        }

        return true;
    }

    /**
     *  Sets the puzzle visual texture to the asset string provided.
     *  This will also change filtering to nearest to avoid any blurry-ness when scaling.
     *  The flipy will also be set back to false since a render texture won't be used.
     *  
     *  @param _asset - The texture assets path.
     */
    public static function imageFromBytes(_puzzleEntity : Visual, _bytes : Bytes)
    {
        var puzzle : data.IPuzzle = cast _puzzleEntity.get('puzzle');
        var tex = new phoenix.Texture({
            id     : 'finalImage',
            pixels : snow.api.buffers.Uint8Array.fromBytes(_bytes),
            width  : puzzle.columns(),
            height : puzzle.rows()
        });
        tex.filter_min = tex.filter_mag = nearest;
        _puzzleEntity.texture = tex;

        // Unflip the geometry now that we're not using the render texture.
        var quadGeom : phoenix.geometry.QuadGeometry = cast _puzzleEntity.geometry;
        quadGeom.flipy = false;
    }
}
