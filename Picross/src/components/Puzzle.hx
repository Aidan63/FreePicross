package components;

import luxe.Component;
import luxe.options.ComponentOptions;
import game.PuzzleState;
import data.PuzzleGrid;
import data.IPuzzle;
import data.events.CellPosition;
import utils.PuzzleHelper;

class Puzzle extends Component implements IPuzzle
{
    /**
     *  The finished puzzle grid.
     *  Used to compare against the active one which the user modifies.
     */
    public var completed : PuzzleGrid;

    /**
     *  The puzzle grid modified by the user.
     */
    public var active : PuzzleGrid;

    /**
     *  The location on disk of the serialized puzzle.
     */
    public var puzzleLocation : String;

    public function new(_options : PuzzleOptions)
    {
        super(_options);
        completed = _options.completedPuzzle;
    }

    override public function onadded()
    {
        active = new PuzzleGrid(rows(), columns());
        
        entity.events.listen('cell.selected', onCellSelected);
    }

    override public function onremoved()
    {
        entity.events.unlisten('cell.selected');
    }

    /**
     *  Gets the number of rows in the puzzle.
     *  @return Int
     */
    public function rows() : Int
    {
        return completed.data.length;
    }

    /**
     *  Gets the number of columns in the puzzle.
     *  @return Int
     */
    public function columns() : Int
    {
        return completed.data[0].length;
    }

    /**
     *  Sets the cell at the provided row and column to the current colour and cell state.
     *  @param _position The position of the cell in the grid.
     */
    private function onCellSelected(_position : CellPosition)
    {
        switch (PuzzleState.cursor.mouse)
        {
            case Brush  : brushCell (_position);
            case Pencil : pencilCell(_position);
            case Rubber : removeCell(_position);
            default:
        }

        if (PuzzleHelper.puzzleComplete(this))
        {
            if (has('mouse')) remove('mouse');
            if (has('gamepad')) remove('gamepad');

            //Luxe.events.fire('puzzle.completed');
            PuzzleState.endPuzzle();
        }
    }

    /**
     *  Attempts to brush the cell at the provided position in the grid.
     *  
     *  If the cell has just been brushed a 'cell.brushed' event containing the position will be fired to the entity.
     *  If the cell is not supposed to be brushed a 'cell.fault' event containing the position will be fired to the entity.
     *  
     *  @param _position The position of the cell to try and brush.
     */
    private function brushCell(_position : CellPosition)
    {
        var actualCell   = active   .data[_position.row][_position.column];
        var expectedCell = completed.data[_position.row][_position.column];

        // If the cell has already been permanently changed exit now.
        if (actualCell.state == Brushed || actualCell.state == Destroyed) return;

        if (expectedCell.state == Brushed && expectedCell.color == PuzzleState.color.currentColor)
        {
            actualCell.state = Brushed;
            actualCell.color = PuzzleState.color.currentColor;
            entity.events.fire('cell.brushed', _position);
        }
        else
        {
            entity.events.fire('cell.fault', _position);
        }
    }

    /**
     *  Pencils in the cell at the provided position if the cell has not already been permanently modified.
     *  @param _position The position of the cell to pencil.
     */
    private function pencilCell(_position : CellPosition)
    {
        var actualCell = active.data[_position.row][_position.column];
        if (actualCell.state == Brushed || actualCell.state == Destroyed) return;

        actualCell.state = Penciled;
        actualCell.color = PuzzleState.color.currentColor;
        entity.events.fire('cell.penciled', _position);
    }

    /**
     *  Attempts to remove the cell at the provided position in the grid.
     *  
     *  If the cell has just been removed a 'cell.removed' event containing the position will be fired to the entity.
     *  If the cell is not supposed to be removed a 'cell.fault' event containing the position will be fired to the entity.
     *  
     *  @param _position The position of the cell to try and remove.
     */
    private function removeCell(_position : CellPosition)
    {
        var actualCell   = active   .data[_position.row][_position.column];
        var expectedCell = completed.data[_position.row][_position.column];

        // If the cell has already been permanently changed exit now.
        if (actualCell.state == Brushed || actualCell.state == Destroyed) return;

        if (expectedCell.state == Destroyed)
        {
            actualCell.state = Destroyed;
            entity.events.fire('cell.removed', _position);
        }
        else
        {
            entity.events.fire('cell.fault', _position);
        }
    }
}

typedef PuzzleOptions = {
    > ComponentOptions,
    var completedPuzzle : PuzzleGrid;
}
