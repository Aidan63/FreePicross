package components;

import luxe.Component;
import luxe.Vector;
import luxe.Visual;
import phoenix.geometry.Geometry;
import components.Dimensions;
import components.Rules;
import game.PuzzleState;
import data.events.LineColor;

class RuleDisplay extends Component
{
    private var rowRules : Array<Array<Geometry>>;
    private var rowRuleBkgs : Array<Array<Geometry>>;

    private var columnRules : Array<Array<Geometry>>;
    private var columnRulesBkgs : Array<Array<Geometry>>;

    private var visual : Visual;

    override public function onadded()
    {
        entity.events.listen('row.completed'   , onRowCompleted);
        entity.events.listen('column.completed', onColumnCompleted);

        visual = cast entity;

        rowRules    = new Array<Array<Geometry>>();
        rowRuleBkgs = new Array<Array<Geometry>>();
        columnRules     = new Array<Array<Geometry>>();
        columnRulesBkgs = new Array<Array<Geometry>>();

        if (has('dimensions') && has('rules'))
        {
            var size    : Dimensions  = cast get('dimensions');
            var rules   : Rules       = cast get('rules');

            // Calculate the top left position of the puzzle display.
            var cellPos : Vector = visual.pos.clone().subtract(visual.origin);

            // Create visuals for row rules.
            for (rowRuleGroup in 0...rules.rowRules.length)
            {
                var ruleGroup    = new Array<Geometry>();
                var ruleBkgGroup = new Array<Geometry>();

                for (rule in 0...rules.rowRules[rowRuleGroup].length)
                {
                    var textPos = cellPos.clone().add_xyz(visual.size.x + (rule * size.cellSize), (rowRuleGroup * size.cellSize));
                    var curRule = rules.rowRules[rowRuleGroup][rule];

                    ruleGroup.push(Luxe.draw.text({
                        pos   : textPos.clone().addScalar(size.cellSize / 2),
                        text  : Std.string(curRule.number),
                        align : center,
                        align_vertical : center,
                        point_size : size.cellSize / 3,
                        color : PuzzleState.color.colors.get(curRule.color).clone()
                    }));

                    switch (curRule.type)
                    {
                        case Continuous : ruleBkgGroup.push(null);
                        case Split : ruleBkgGroup.push(Luxe.draw.texture({
                                            x : textPos.x,
                                            y : textPos.y,
                                            w : size.cellSize,
                                            h : size.cellSize,
                                            texture : Luxe.resources.texture('assets/images/RuleCircle.png'),
                                            color : PuzzleState.color.colors.get(curRule.color).clone()
                                        }));
                        case Group : ruleBkgGroup.push(Luxe.draw.texture({
                                            x : textPos.x,
                                            y : textPos.y,
                                            w : size.cellSize,
                                            h : size.cellSize,
                                            texture : Luxe.resources.texture('assets/images/RuleSquare.png'),
                                            color : PuzzleState.color.colors.get(curRule.color).clone()
                                        }));
                    }
                }

                rowRules.push(ruleGroup);
                rowRuleBkgs.push(ruleBkgGroup);
            }

            // Create visuals for column rules.
            for (colRuleGroup in 0...rules.columnRules.length)
            {
                var ruleGroup    = new Array<Geometry>();
                var ruleBkgGroup = new Array<Geometry>();

                for (rule in 0...rules.columnRules[colRuleGroup].length)
                {
                    var textPos = cellPos.clone().add_xyz(colRuleGroup * size.cellSize, - (size.cellSize + (rule * size.cellSize)));
                    var curRule = rules.columnRules[colRuleGroup][rule];

                    ruleGroup.push(Luxe.draw.text({
                        pos   : textPos.clone().addScalar(size.cellSize / 2),
                        text  : Std.string(curRule.number),
                        align : center,
                        align_vertical : center,
                        point_size : size.cellSize / 3,
                        color : PuzzleState.color.colors.get(curRule.color).clone()
                    }));

                    switch (curRule.type)
                    {
                        case Continuous : ruleBkgGroup.push(null);
                        case Split : ruleBkgGroup.push(Luxe.draw.texture({
                                            x : textPos.x,
                                            y : textPos.y,
                                            w : size.cellSize,
                                            h : size.cellSize,
                                            texture : Luxe.resources.texture('assets/images/RuleCircle.png'),
                                            color : PuzzleState.color.colors.get(curRule.color).clone()
                                        }));
                        case Group : ruleBkgGroup.push(Luxe.draw.texture({
                                            x : textPos.x,
                                            y : textPos.y,
                                            w : size.cellSize,
                                            h : size.cellSize,
                                            texture : Luxe.resources.texture('assets/images/RuleSquare.png'),
                                            color : PuzzleState.color.colors.get(curRule.color).clone()
                                        }));
                    }
                }

                columnRules.push(ruleGroup);
                columnRulesBkgs.push(ruleBkgGroup);
            }
        }
    }

    override public function onremoved()
    {
        entity.events.unlisten('row.completed');
        entity.events.unlisten('column.completed');

        for (group in rowRules)
        {
            for (rule in group)
            {
                rule.drop();
            }
        }
        for (group in rowRuleBkgs)
        {
            for (rule in group)
            {
                if (rule != null) rule.drop();
            }
        }

        for (group in columnRules)
        {
            for (rule in group)
            {
                rule.drop();
            }
        }
        for (group in columnRulesBkgs)
        {
            for (rule in group)
            {
                if (rule != null) rule.drop();
            }
        }
    }

    private function onRowCompleted(_row : LineColor)
    {
        var ruleGroup = rowRules[_row.number];
        var bkgGroup  = rowRuleBkgs[_row.number];

        switch (_row.color)
        {
            case Primary:
                ruleGroup[0].color.a = 0.5;
                if (bkgGroup[0] != null) bkgGroup[0].color.a = 0.25;
            case Secondary:
                ruleGroup[1].color.a = 0.5;
                if (bkgGroup[1] != null) bkgGroup[1].color.a = 0.25;
        }
    }

    private function onColumnCompleted(_column : LineColor)
    {
        var ruleGroup = columnRules[_column.number];
        var bkgGroup  = columnRulesBkgs[_column.number];

        switch (_column.color)
        {
            case Primary:
                ruleGroup[0].color.a = 0.5;
                if (bkgGroup[0] != null) bkgGroup[0].color.a = 0.25;
            case Secondary:
                ruleGroup[1].color.a = 0.5;
                if (bkgGroup[1] != null) bkgGroup[1].color.a = 0.25;
        }
    }

    public function fadeOut()
    {
        for (group in rowRules)
        {
            for (rule in group)
            {
                rule.color.tween(0.25, { a : 0 });
            }
        }
        for (group in rowRuleBkgs)
        {
            for (rule in group)
            {
                if (rule != null) rule.color.tween(0.25, { a : 0 });
            }
        }

        for (group in columnRules)
        {
            for (rule in group)
            {
                rule.color.tween(0.25, { a : 0 });
            }
        }
        for (group in columnRulesBkgs)
        {
            for (rule in group)
            {
                if (rule != null) rule.color.tween(0.25, { a : 0 });
            }
        }

        Luxe.timer.schedule(0.3, function() {
            remove(name);
        });
    }
}
