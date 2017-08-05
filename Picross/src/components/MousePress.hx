package components;

import luxe.Component;
import luxe.Input;
import luxe.Vector;
import luxe.Visual;
import components.Dimensions;
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

    /**
     *  This components entity cast as a visual.
     */
    private var visual : Visual;

    override public function onmousedown(_event : MouseEvent)
    {
        visual = cast entity;

        // Update the current mouse cursor state.
        PuzzleState.cursor.setMouseCursorFromButton(_event.button);

        // Check to see if the mouse has been pressed on the grid.
        if (has('dimensions'))
        {
            var dimensions : Dimensions = cast get('dimensions');

            // Convert the mouse screen press to world coordinates then get the top left position of the puzzle display.
            var mouse      : Vector = Luxe.camera.screen_point_to_world(_event.pos);
            var displayPos : Vector = visual.pos.clone().subtract(visual.origin);
            
            if (mouse.x > displayPos.x && mouse.y > displayPos.y && mouse.x < (displayPos.x + visual.size.x) && mouse.y < (displayPos.y + visual.size.y))
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

        if (has('dimensions'))
        {
            var dimensions : Dimensions = cast get('dimensions');

            // Convert the mouse screen press to world coordinates then get the top left position of the puzzle display.
            var mouse      : Vector = Luxe.camera.screen_point_to_world(_event.pos);
            var displayPos : Vector = visual.pos.clone().subtract(visual.origin);

            if (mouse.x > displayPos.x && mouse.y > displayPos.y && mouse.x < (displayPos.x + visual.size.x) && mouse.y < (displayPos.y + visual.size.y))
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
