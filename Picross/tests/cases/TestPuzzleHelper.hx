package cases;

import utest.Assert;
import luxe.Entity;
import data.PuzzleGrid;
import data.events.CellPosition;
import game.PuzzleState;
import utils.PuzzleHelper;

class TestPuzzleHelper
{
    private var entity : Entity;
    private var grid : PuzzleGrid;

    public function new() {}

    public function setup()
    {
        PuzzleState.init();

        // Create a puzzle grid and fill its cells.
        grid = new PuzzleGrid(2, 4);

        // First row
        grid.data[0][0].state = Brushed;
        grid.data[0][0].color = Primary;
        grid.data[0][1].state = Brushed;
        grid.data[0][1].color = Primary;
        grid.data[0][2].state = Brushed;
        grid.data[0][2].color = Secondary;
        grid.data[0][3].state = Brushed;
        grid.data[0][3].color = Secondary;
        // Second row
        grid.data[1][0].state = Brushed;
        grid.data[1][0].color = Secondary;
        grid.data[1][1].state = Brushed;
        grid.data[1][1].color = Primary;
        grid.data[1][2].state = Brushed;
        grid.data[1][2].color = Primary;
        grid.data[1][3].state = Brushed;
        grid.data[1][3].color = Primary;

        entity = new Entity({ name : 'grid' });
        entity.add(new components.Puzzle({
            name : 'puzzle',
            completedPuzzle : grid
        }));

        PuzzleState.cursor.mouse = Brush;

        // Send events to the entity to complete the first row.
        PuzzleState.color.currentColor = Primary;
        entity.events.fire('cell.selected', new CellPosition(0, 0));
        entity.events.fire('cell.selected', new CellPosition(0, 1));
        PuzzleState.color.currentColor = Secondary;
        entity.events.fire('cell.selected', new CellPosition(0, 2));
        entity.events.fire('cell.selected', new CellPosition(0, 3));

        // Send events to the entity to fill the first cell, destroy the second, pencil the third, and leave the fourth.
        PuzzleState.color.currentColor = Secondary;
        entity.events.fire('cell.selected', new CellPosition(1, 0));
        PuzzleState.cursor.mouse = Rubber;
        entity.events.fire('cell.selected', new CellPosition(1, 1));
        PuzzleState.cursor.mouse = Pencil;
        entity.events.fire('cell.selected', new CellPosition(1, 2));
    }

    public function testRowCompleted()
    {
        var puzzle : components.Puzzle = cast entity.get('puzzle');
        Assert.isTrue(PuzzleHelper.rowCompleted(0, puzzle), 'Row 0 on the puzzle grid is not complete when it should be');
        Assert.isFalse(PuzzleHelper.rowCompleted(1, puzzle), 'Row 1 on the puzzle grid is complete when it should be');
    }

    public function testColumnCompleted()
    {
        var puzzle : components.Puzzle = cast entity.get('puzzle');
        Assert.isTrue (PuzzleHelper.columnCompleted(0, puzzle), 'Column 1 on the puzzle grid is not complete when it should be');
        Assert.isFalse(PuzzleHelper.columnCompleted(1, puzzle), 'Column 2 on the puzzle grid is complete when it should be');
        Assert.isFalse(PuzzleHelper.columnCompleted(2, puzzle), 'Column 3 on the puzzle grid is complete when it should be');
        Assert.isFalse(PuzzleHelper.columnCompleted(3, puzzle), 'Column 4 on the puzzle grid is complete when it should be');
    }

    public function testColumnAsArray()
    {
        var cell1 = new PuzzleCell(0, 0);
        cell1.color = Primary;
        cell1.state = Brushed;
        var cell2 = new PuzzleCell(1, 0);
        cell2.color = Secondary;
        cell2.state = Brushed;

        var expectedColumn : Array<PuzzleCell> = [ cell1, cell2 ];
        var puzzle : components.Puzzle = cast entity.get('puzzle');

        Assert.same(expectedColumn, PuzzleHelper.columnAsArray(puzzle, 0));
    }

    public function testRowCellColorCompleted()
    {
        var puzzle : components.Puzzle = cast entity.get('puzzle');

        Assert.isTrue(PuzzleHelper.rowCellColorCompleted(puzzle, Primary  , 0), 'The primary colour in the first row should be complete but is not.');
        Assert.isTrue(PuzzleHelper.rowCellColorCompleted(puzzle, Secondary, 0), 'The secondary colour in the first row should be complete but is not.');

        Assert.isFalse(PuzzleHelper.rowCellColorCompleted(puzzle, Primary  , 1), 'The primary colour in the second row should not be complete but is.');
        Assert.isTrue (PuzzleHelper.rowCellColorCompleted(puzzle, Secondary, 1), 'The secondary colour in the first row should be complete but is not.');
    }

    public function testColumnCellColorCompleted()
    {
        var puzzle : components.Puzzle = cast entity.get('puzzle');

        Assert.isTrue(PuzzleHelper.columnCellColorComplete(puzzle, Primary  , 0), 'The primary colour in the first column should be complete but is not.');
        Assert.isTrue(PuzzleHelper.columnCellColorComplete(puzzle, Secondary, 0), 'The secondary colour in the first column should be complete but is not.');

        Assert.isFalse(PuzzleHelper.columnCellColorComplete(puzzle, Primary  , 3), 'The primary colour in the third column should not be complete but is.');
        Assert.isTrue (PuzzleHelper.columnCellColorComplete(puzzle, Secondary, 3), 'The secondary colour in the third column should be complete but is not.');
    }

    public function testPuzzleComplete()
    {
        var puzzle : components.Puzzle = cast entity.get('puzzle');
        Assert.isFalse(PuzzleHelper.puzzleComplete(puzzle), 'Puzzle is completed when it should not be');

        // Create a new small grid to test if it's complete since the other entity has a removed cell.
        var secondGrid = new PuzzleGrid(2, 4);

        secondGrid.data[0][0].state = Brushed;
        secondGrid.data[0][0].color = Primary;
        secondGrid.data[0][1].state = Brushed;
        secondGrid.data[0][1].color = Secondary;
        secondGrid.data[1][0].state = Brushed;
        secondGrid.data[1][0].color = Secondary;
        secondGrid.data[1][1].state = Brushed;
        secondGrid.data[1][1].color = Primary;

        var secondEntity = new Entity({ name : 'grid' });
        secondEntity.add(new components.Puzzle({
            name : 'puzzle',
            completedPuzzle : secondGrid
        }));

        PuzzleState.cursor.mouse = Brush;

        // Send events to the entity to complete the first row.
        PuzzleState.color.currentColor = Primary;
        secondEntity.events.fire('cell.selected', new CellPosition(0, 0));
        secondEntity.events.fire('cell.selected', new CellPosition(1, 1));
        PuzzleState.color.currentColor = Secondary;
        secondEntity.events.fire('cell.selected', new CellPosition(0, 1));
        secondEntity.events.fire('cell.selected', new CellPosition(1, 0));

        Assert.isTrue(PuzzleHelper.puzzleComplete(cast secondEntity.get('puzzle')));

        secondEntity.destroy();
    }

    public function teardown()
    {
        entity.destroy();
    }
}
