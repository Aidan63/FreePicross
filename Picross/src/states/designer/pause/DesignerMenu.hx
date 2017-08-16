package states.designer.pause;

import luxe.States;
import luxe.Visual;

class DesignerMenu extends State
{
    private var menu : Visual;

    public function new(_options : luxe.options.StateOptions)
    {
        super(_options);

        menu = ui.designer.DesignerUI.menu();
        menu.pos.set_xy(320, -560);
    }

    override public function onenter<T>(_data : T)
    {
        luxe.tween.Actuate.tween(menu.pos, 0.1, { y : 80 });
    }

    override public function onleave<T>(_data : T)
    {
        //
    }

    override public function ondestroy()
    {
        trace('Cleaning up');
        menu.destroy();
    }
}
