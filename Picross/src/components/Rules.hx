package components;

import luxe.Component;
import components.Puzzle;
import game.ColorSelector;
import data.events.CellPosition;
import data.events.LineColor;
import utils.PuzzleHelper;

enum RuleType {
    Continuous;
    Split;
    Group;
}

typedef TempRule = {
    var type : ColorTypes;
    var count : Int;
}

class Rules extends Component
{
    /**
     *  2D array to hold all of the row rules for this puzzle.
     */
    public var rowRules : Array<Array<Rule>>;

    /**
     *  2D array to hold all of the row rule numbers backgrounds for this puzzle.
     *  If the rule doesn't need a background the value will be null.
     */
    public var columnRules : Array<Array<Rule>>;

    override public function onadded()
    {
        entity.events.listen('cell.brushed', updateRules);
        entity.events.listen('cell.removed', updateRules);

        rowRules    = new Array<Array<Rule>>();
        columnRules = new Array<Array<Rule>>();

        if (has('puzzle'))
        {
            createRowRules();
            createColumnRules();
        }
    }

    override public function onremoved()
    {
        entity.events.unlisten('cell.brushed');
        entity.events.unlisten('cell.removed');
    }

    /**
     *  Creates an array of temp rules for each row and sends them to setRules to be analyised.
     */
    private function createRowRules()
    {
        var puzzle : Puzzle = cast get('puzzle');

        for (row in 0...puzzle.rows())
        {
            // Create a set of temp rules based on the current row then convert them to the rows actual rules.
            // Adjacent cells of the same color get converted into one temp rule.
            var rules = new Array<TempRule>();
            var prevColor : ColorTypes = null;

            for (cell in puzzle.completed.data[row])
            {
                // Skip loop if the cell is not brushed.
                if (cell.state != Brushed)
                {
                    prevColor = null;
                    continue;
                }

                // If the current cell has the same color as the last increment the last temp rules count.
                // Else create a new temp rule.
                if (cell.color != prevColor)
                {
                    rules.push({ type : cell.color, count : 1 });
                }
                else
                {
                    rules[rules.length -1].count ++;
                }

                prevColor = cell.color;
            }

            setRules("row", rules);
        }
    }

    /**
     *  Creates an array of temp rules for each column and sends them to setRules to be analyised.
     */
    private function createColumnRules()
    {
        var puzzle : Puzzle = cast get('puzzle');

        for (col in 0...puzzle.columns())
        {
            var rules = new Array<TempRule>();
            var prevColor : ColorTypes = null;

            for (cell in PuzzleHelper.columnAsArray(puzzle, col))
            {
                if (cell.state != Brushed)
                {
                    prevColor = null;
                    continue;
                }

                if (cell.color != prevColor)
                {
                    rules.push({ type : cell.color, count : 1 });
                }
                else
                {
                    rules[rules.length - 1].count ++;
                }

                prevColor = cell.color;
            }

            setRules("col", rules);
        }
    }

    /**
     *  Converts a set of temp rules into actual primary and secondary rules.
     *  @param _type If theses rules are for a row or column.
     *  @param _rules The array of temp rules.
     */
    private function setRules(_type : String, _rules : Array<TempRule>)
    {
        var primaryRule   = new Rule(Primary);
        var secondaryRule = new Rule(Secondary);
        for (tmp in _rules)
        {
            switch (tmp.type)
            {
                case Primary :
                    primaryRule.number += tmp.count;

                case Secondary :
                    secondaryRule.number += tmp.count;
            }
        }

        switch (_type)
        {
            case 'row' : rowRules.push([ primaryRule, secondaryRule ]);
            case 'col' : columnRules.push([ primaryRule, secondaryRule ]);
        }
    }

    //

    private function updateRules(_position : CellPosition)
    {
        if (has('puzzle'))
        {
            updateRowRules(_position.row);
            updateColumnRules(_position.column);
        }
    }

    private function updateRowRules(_row : Int)
    {
        var puzzle : Puzzle = cast get('puzzle');

        var primaryComplete   = PuzzleHelper.rowCellColorCompleted(puzzle, Primary  , _row);
        var secondaryComplete = PuzzleHelper.rowCellColorCompleted(puzzle, Secondary, _row);

        if (primaryComplete)
        {
            rowRules[_row][0].completed = true;
            entity.events.fire('row.color.completed', new LineColor(_row, Primary));
        }
        if (secondaryComplete)
        {
            rowRules[_row][1].completed = true;
            entity.events.fire('row.color.completed', new LineColor(_row, Secondary));
        }

        // If both colours have been complete fire an event so the rule display can fade the row to 0.
        if (PuzzleHelper.rowCompleted(_row, puzzle))
        {
            entity.events.fire('row.completed', _row);
        }
    }

    private function updateColumnRules(_column : Int)
    {
        var puzzle : Puzzle = cast get('puzzle');

        var primaryComplete   = PuzzleHelper.columnCellColorComplete(puzzle, Primary  , _column);
        var secondaryComplete = PuzzleHelper.columnCellColorComplete(puzzle, Secondary, _column);

        if (primaryComplete)
        {
            columnRules[_column][0].completed = true;
            entity.events.fire('column.color.completed', new LineColor(_column, Primary));
        }
        if (secondaryComplete)
        {
            columnRules[_column][1].completed = true;
            entity.events.fire('column.color.completed', new LineColor(_column, Secondary));
        }

        // If both colours have been complete fire an event so the rule display can fade the column to 0.
        if (PuzzleHelper.columnCompleted(_column, puzzle))
        {
            entity.events.fire('column.completed', _column);
        }
    }
}

private class Rule
{
    /**
     *  The type of this rule.
     */
    public var type : RuleType;

    /**
     *  The colour of this rule.
     */
    public var color : ColorTypes;

    /**
     *  The number of blocks of this colour.
     */
    public var number(default, set) : Int;

    /**
     *  If this rule has been completed.
     */
    public var completed : Bool;

    private var internalCount : Int;

    public function new(_color : ColorTypes)
    {
        type   = Continuous;
        color  = _color;
        number = 0;
        completed = false;
        internalCount = 0;
    }

    private function set_number(_value : Int) : Int
    {
        internalCount++;
        switch(Math.min(internalCount, 3))
        {
            case 1 : type = Continuous;
            case 2 : type = Split;
            case 3 : type = Group;
        }

        return number = _value;
    }
}
