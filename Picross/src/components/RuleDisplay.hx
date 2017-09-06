package components;

import luxe.Component;
import luxe.Vector;
import luxe.Visual;
import luxe.Rectangle;
import phoenix.geometry.QuadPackGeometry;
import phoenix.geometry.TextGeometry;

import components.Dimensions;
import components.Rules;
import game.PuzzleState;
import game.ColorSelector.ColorTypes;
import data.events.LineColor;

class RuleDisplay extends Component
{
    private var rowRules : Array<Map<ColorTypes, TextGeometry>>;
    private var rowRulesIDs : Array<Map<ColorTypes, Int>>;
    private var rowRulesBkgs : QuadPackGeometry;

    private var columnRules : Array<Map<ColorTypes, TextGeometry>>;
    private var columnRulesIDs : Array<Map<ColorTypes, Int>>;
    private var columnRulesBkgs : QuadPackGeometry;

    private var visual : Visual;

    private var listenRowComplete : String;
    private var listenColComplete : String;

    override public function onadded()
    {
        listenRowComplete = entity.events.listen('row.color.completed'   , onRowColorCompleted);
        listenRowComplete = entity.events.listen('column.color.completed', onColumnColorCompleted);

        visual = cast entity;

        rowRules     = new Array<Map<ColorTypes, TextGeometry>>();
        rowRulesIDs  = new Array<Map<ColorTypes, Int>>();
        rowRulesBkgs = new QuadPackGeometry({
            texture : Luxe.resources.texture('assets/images/rules.png'),
            batcher : Luxe.renderer.batcher
        });

        columnRules     = new Array<Map<ColorTypes, TextGeometry>>();
        columnRulesIDs  = new Array<Map<ColorTypes, Int>>();
        columnRulesBkgs = new QuadPackGeometry({
            texture : Luxe.resources.texture('assets/images/rules.png'),
            batcher : Luxe.renderer.batcher
        });

        if (has('dimensions') && has('rules'))
        {
            var size    : Dimensions  = cast get('dimensions');
            var rules   : Rules       = cast get('rules');

            // Calculate the top left position of the puzzle display.
            var displayPos : Vector = visual.pos.clone().subtract(visual.origin);

            // Create visuals for row rules.
            for (i in 0...rules.rowRules.length)
            {
                var groupID   = new Map<ColorTypes, Int>();
                var groupText = new Map<ColorTypes, TextGeometry>();

                for (j in 0...rules.rowRules[i].length)
                {
                    var thisRule = rules.rowRules[i][j];
                    var rulePos  = displayPos.clone().add_xyz(visual.size.x + (j * size.cellSize), i * size.cellSize);

                    // Create the text geometry for this rule.
                    groupText.set(thisRule.color, Luxe.draw.text({
                        pos   : rulePos.clone().addScalar(size.cellSize / 2),
                        text  : Std.string(thisRule.number),
                        align : center,
                        align_vertical : center,
                        point_size : size.cellSize / 3,
                        color : PuzzleState.color.colors.get(thisRule.color).clone()
                    }));

                    // Create any background.
                    switch(thisRule.type)
                    {
                        case Split : groupID.set(thisRule.color, rowRulesBkgs.quad_add({
                            x : rulePos.x,
                            y : rulePos.y,
                            w : size.cellSize,
                            h : size.cellSize,
                            uv : new Rectangle(0, 0, 128, 128),
                            color : PuzzleState.color.colors.get(thisRule.color).clone()
                        }));
                        case Group : groupID.set(thisRule.color, rowRulesBkgs.quad_add({
                            x : rulePos.x,
                            y : rulePos.y,
                            w : size.cellSize,
                            h : size.cellSize,
                            uv : new Rectangle(128, 0, 128, 128),
                            color : PuzzleState.color.colors.get(thisRule.color).clone()
                        }));
                        default:
                    }
                }

                rowRules.push(groupText);
                rowRulesIDs.push(groupID);
            }

            // Create visuals for row rules.
            for (i in 0...rules.columnRules.length)
            {
                var groupID   = new Map<ColorTypes, Int>();
                var groupText = new Map<ColorTypes, TextGeometry>();

                for (j in 0...rules.columnRules[i].length)
                {
                    var thisRule = rules.columnRules[i][j];
                    var rulePos  = displayPos.clone().add_xyz(i * size.cellSize, -(size.cellSize + j * size.cellSize));

                    // Create the text geometry for this rule.
                    groupText.set(thisRule.color, Luxe.draw.text({
                        pos   : rulePos.clone().addScalar(size.cellSize / 2),
                        text  : Std.string(thisRule.number),
                        align : center,
                        align_vertical : center,
                        point_size : size.cellSize / 3,
                        color : PuzzleState.color.colors.get(thisRule.color).clone()
                    }));

                    // Create any background.
                    switch(thisRule.type)
                    {
                        case Split : groupID.set(thisRule.color, columnRulesBkgs.quad_add({
                            x : rulePos.x,
                            y : rulePos.y,
                            w : size.cellSize,
                            h : size.cellSize,
                            uv : new Rectangle(0, 0, 128, 128),
                            color : PuzzleState.color.colors.get(thisRule.color).clone()
                        }));
                        case Group : groupID.set(thisRule.color, columnRulesBkgs.quad_add({
                            x : rulePos.x,
                            y : rulePos.y,
                            w : size.cellSize,
                            h : size.cellSize,
                            uv : new Rectangle(128, 0, 128, 128),
                            color : PuzzleState.color.colors.get(thisRule.color).clone()
                        }));
                        default:
                    }
                }

                columnRules.push(groupText);
                columnRulesIDs.push(groupID);
            }
        }
    }

    override public function onremoved()
    {
        entity.events.unlisten(listenRowComplete);
        entity.events.unlisten(listenColComplete);

        for (group in rowRules)
        {
            for (rule in group)
            {
                rule.drop();
            }
        }
        rowRulesBkgs.drop();

        for (group in columnRules)
        {
            for (rule in group)
            {
                rule.drop();
            }
        }
        columnRulesBkgs.drop();
    }

    private function onRowColorCompleted(_row : LineColor)
    {
        var ruleGroup : Map<ColorTypes, TextGeometry> = rowRules[_row.number];
        var quadGroup : Map<ColorTypes, Int> = rowRulesIDs[_row.number];

        if (ruleGroup.exists(_row.color)) ruleGroup.get(_row.color).color.a = 0.5;
        if (quadGroup.exists(_row.color)) rowRulesBkgs.quad_alpha(quadGroup.get(_row.color), 0.5);
    }

    private function onColumnColorCompleted(_column : LineColor)
    {
        var ruleGroup : Map<ColorTypes, TextGeometry> = columnRules[_column.number];
        var quadGroup : Map<ColorTypes, Int> = columnRulesIDs[_column.number];

        if (ruleGroup.exists(_column.color)) ruleGroup.get(_column.color).color.a = 0.5;
        if (quadGroup.exists(_column.color)) columnRulesBkgs.quad_alpha(quadGroup.get(_column.color), 0.5);
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
        for (quad in rowRulesBkgs.quads)
        {
            for (ver in quad.verts)
            {
                ver.color.tween(0.25, { a : 0 });
            }
        }
        
        for (group in columnRules)
        {
            for (rule in group)
            {
                rule.color.tween(0.25, { a : 0 });
            }
        }
        for (quad in columnRulesBkgs.quads)
        {
            for (ver in quad.verts)
            {
                ver.color.tween(0.25, { a : 0 });
            }
        }

        Luxe.timer.schedule(0.3, function() {
            remove(name);
        });
    }
}
