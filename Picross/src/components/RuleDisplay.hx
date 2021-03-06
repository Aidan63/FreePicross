package components;

import luxe.Component;
import luxe.Vector;
import luxe.Visual;
import luxe.Rectangle;
import luxe.tween.Actuate;
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
    private var listenRowColorComplete : String;
    private var listenColColorComplete : String;

    override public function onadded()
    {
        listenRowComplete = entity.events.listen('row.completed', onRowCompleted);
        listenColComplete = entity.events.listen('column.completed', onColumnCompleted);
        listenRowColorComplete = entity.events.listen('row.color.completed'   , onRowColorCompleted);
        listenColColorComplete = entity.events.listen('column.color.completed', onColumnColorCompleted);

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
                    var textColor = PuzzleState.color.colors.get(thisRule.color).clone();
                    thisRule.number == 0 ? textColor.a = 0.5 : textColor.a = 1;
                    groupText.set(thisRule.color, Luxe.draw.text({
                        pos   : rulePos.clone().addScalar(size.cellSize / 2),
                        text  : Std.string(thisRule.number),
                        align : center,
                        align_vertical : center,
                        point_size : size.cellSize / 3,
                        color : textColor
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

            // Create visuals for column rules.
            for (i in 0...rules.columnRules.length)
            {
                var groupID   = new Map<ColorTypes, Int>();
                var groupText = new Map<ColorTypes, TextGeometry>();

                for (j in 0...rules.columnRules[i].length)
                {
                    var thisRule = rules.columnRules[i][j];
                    var rulePos  = displayPos.clone().add_xyz(i * size.cellSize, -(size.cellSize + j * size.cellSize));

                    // Create the text geometry for this rule.
                    var textColor = PuzzleState.color.colors.get(thisRule.color).clone();
                    thisRule.number == 0 ? textColor.a = 0.5 : textColor.a = 1;
                    groupText.set(thisRule.color, Luxe.draw.text({
                        pos   : rulePos.clone().addScalar(size.cellSize / 2),
                        text  : Std.string(thisRule.number),
                        align : center,
                        align_vertical : center,
                        point_size : size.cellSize / 3,
                        color : textColor
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
        entity.events.unlisten(listenRowColorComplete);
        entity.events.unlisten(listenColColorComplete);

        for (group in rowRules)
        {
            for (rule in group)
            {
                Actuate.stop(rule.color);
                rule.drop();
            }
        }
        rowRulesBkgs.drop();
        Actuate.stop(rowRulesBkgs.color);

        for (group in columnRules)
        {
            for (rule in group)
            {
                Actuate.stop(rule.color);
                rule.drop();
            }
        }
        columnRulesBkgs.drop();
        Actuate.stop(columnRulesBkgs.color);
    }

    /**
     *  Set the alpha of one of the rules colours to 0.5 to indicate that colour is done.
     *  @param _row - Contains the row number and the rule colour to effect.
     */
    private function onRowColorCompleted(_row : LineColor)
    {
        var ruleGroup : Map<ColorTypes, TextGeometry> = rowRules[_row.number];
        var quadGroup : Map<ColorTypes, Int> = rowRulesIDs[_row.number];

        if (ruleGroup.exists(_row.color)) ruleGroup.get(_row.color).color.a = 0.5;
        if (quadGroup.exists(_row.color)) rowRulesBkgs.quad_alpha(quadGroup.get(_row.color), 0.5);
    }

    /**
     *  Set the alpha of one of the rules colours to 0.5 to indicate that colour is done.
     *  @param _column - Contains the column number and the rule colour to effect.
     */
    private function onColumnColorCompleted(_column : LineColor)
    {
        var ruleGroup : Map<ColorTypes, TextGeometry> = columnRules[_column.number];
        var quadGroup : Map<ColorTypes, Int> = columnRulesIDs[_column.number];

        if (ruleGroup.exists(_column.color)) ruleGroup.get(_column.color).color.a = 0.5;
        if (quadGroup.exists(_column.color)) columnRulesBkgs.quad_alpha(quadGroup.get(_column.color), 0.5);
    }

    /**
     *  Called when a row has been completed (breaking blocks included)
     *  tween the rule numbers and backgrounds alpha for that row to 0.
     *  @param _row - The row to fade out.
     */
    private function onRowCompleted(_row : Int)
    {
        var ruleGroup : Map<ColorTypes, TextGeometry> = rowRules[_row];
        var quadGroup : Map<ColorTypes, Int> = rowRulesIDs[_row];

        for (rule in ruleGroup)
        {
            rule.color.tween(0.5, { a : 0 });
        }
        for (quadID in quadGroup)
        {
            // No way to tween a quads color so we tween each vert colour instead.
            var quad = rowRulesBkgs.quads.get(quadID);
            for (vert in quad.verts)
            {
                vert.color.tween(0.5, { a : 0 });
            }
        }
    }

    /**
     *  Called when a row has been completed (breaking blocks included)
     *  tween the rule numbers and backgrounds alpha for that row to 0.
     *  @param _column - The column to fade out.
     */
    private function onColumnCompleted(_column : Int)
    {
        var ruleGroup : Map<ColorTypes, TextGeometry> = columnRules[_column];
        var quadGroup : Map<ColorTypes, Int> = columnRulesIDs[_column];

        for (rule in ruleGroup)
        {
            rule.color.tween(0.5, { a : 0 });
        }
        for (quadID in quadGroup)
        {
            // No way to tween a quads color so we tween each vert colour instead.
            var quad = columnRulesBkgs.quads.get(quadID);
            for (vert in quad.verts)
            {
                vert.color.tween(0.5, { a : 0 });
            }
        }
    }

    public function fadeOut()
    {
        Luxe.timer.schedule(0.5, function() {
            remove(name);
        });
    }
}
