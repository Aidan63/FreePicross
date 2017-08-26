package game;

import game.Cursor;
import game.ColorSelector;

class PuzzleState
{
    /**
     *  Holds the current colour and mappings to luxe colours.
     */
    public static var color : ColorSelector;

    /**
     *  The cursors current state.
     */
    public static var cursor : Cursor;

    public static function init()
    {
        color  = new ColorSelector();
        cursor = new Cursor();
    }
}
