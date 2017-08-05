package components;

import luxe.Component;
import luxe.Input;
import luxe.Vector;
import components.Dimensions;
import components.Display;
import game.PuzzleState;

class MousePress extends Component
{
    /**
     *  The last row the mouse was over.
     */
    private var lastRow : Int;

    /**
     *  The last column the mouse was over.
     */
    private var lastColumn : Int;

    override public function onmousedown(_event : MouseEvent)
    {
        // Update the current mouse cursor state.
        PuzzleState.cursor.setMouseCursorFromButton(_event.button);

        // Check to see if the mouse has been pressed on the grid.
        if (has('dimensions') && has('display'))
        {
            var parent : luxe.Visual = cast entity;
            var dimensions : Dimensions = cast get('dimensions');
            var display : Display = cast get('display');

            // Convert the mouse screen press to world coordinates then get the top left position of the puzzle display.
            var mouse      : Vector = Luxe.camera.screen_point_to_world(_event.pos);
            var displayPos : Vector = display.data.display.pos.clone().subtract(display.data.display.origin);
            
            if (mouse.x > displayPos.x && mouse.y > displayPos.y && mouse.x < (displayPos.x + parent.size.x) && mouse.y < (displayPos.y + parent.size.y))
            {
                var mouseDisplayPos : Vector = mouse.clone().subtract(displayPos);

                lastRow    = Math.floor(mouseDisplayPos.y / dimensions.cellSize);
                lastColumn = Math.floor(mouseDisplayPos.x / dimensions.cellSize);

                entity.events.fire('cell.selected', new data.events.CellPosition(lastRow, lastColumn));
            }
        }
    }

    override public function onmousemove(_event : MouseEvent)
    {
        if (PuzzleState.cursor.mouse == None)
        {
            return;
        }

        if (has('dimensions') && has('display'))
        {
            var parent : luxe.Visual = cast entity;
            var dimensions : Dimensions = cast get('dimensions');
            var display : Display = cast get('display');

            // Convert the mouse screen press to world coordinates then get the top left position of the puzzle display.
            var mouse      : Vector = Luxe.camera.screen_point_to_world(_event.pos);
            var displayPos : Vector = display.data.display.pos.clone().subtract(display.data.display.origin);

            if (mouse.x > displayPos.x && mouse.y > displayPos.y && mouse.x < (displayPos.x + parent.size.x) && mouse.y < (displayPos.y + parent.size.y))
            {
                var mouseDisplayPos : Vector = mouse.clone().subtract(displayPos);

                var row    = Math.floor(mouseDisplayPos.y / dimensions.cellSize);
                var column = Math.floor(mouseDisplayPos.x / dimensions.cellSize);

                if (lastRow != row || lastColumn != column)
                {
                    lastRow    = row;
                    lastColumn = column;

                    entity.events.fire('cell.selected', new data.events.CellPosition(lastRow, lastColumn));
                }
            }
        }
    }

    override public function onmouseup(_event : MouseEvent)
    {
        PuzzleState.cursor.setMouseCursorFromButton(MouseButton.none);
    }
}
