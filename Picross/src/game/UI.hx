package game;

import luxe.Visual;
import ui.game.GameUI;
import ui.game.PuzzleResults;

class UI
{
    public var hud : GameUI;
    public var results : PuzzleResults;

    public var newHud : Visual;

    public function new() {}

    public function disableHud()
    {
        for (child in newHud.children)
        {
            child.active = false;

            if (child.name == 'ui_paintsHolder')
            {
                for (paint in child.children) paint.active = false;
            }
        }
    }

    public function enableHud()
    {
        for (child in newHud.children)
        {
            child.active = true;

            if (child.name == 'ui_paintsHolder')
            {
                for (paint in child.children) paint.active = true;
            }
        }
    }
}
