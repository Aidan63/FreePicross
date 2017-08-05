package game;

import luxe.Input;

class Cursor
{
    /**
     *  The state of the mouse cursor.
     */
    public var mouse : CursorType;

    /**
     *  The state of the keyboard and gamepad cursor.
     */
    public var gp : CursorType;

    public function new()
    {
        mouse = CursorType.None;
        gp = CursorType.None;
    }

    /**
     *  Sets the mouse cursor state based on the provided MouseButton type.
     *  @param _mouse The mouse button type.
     */
    public function setMouseCursorFromButton(_mouse : MouseButton)
    {
        switch (_mouse)
        {
            case MouseButton.left   : PuzzleState.cursor.mouse = Brush;
            case MouseButton.middle : PuzzleState.cursor.mouse = Rubber;
            case MouseButton.right  : PuzzleState.cursor.mouse = Pencil;
            default : PuzzleState.cursor.mouse = None;
        }
    }
}

enum CursorType {
    None;
    Brush;
    Pencil;
    Rubber;
    Clean;
}
