package states.ugc;

import luxe.States;
import luxe.Visual;
import luxe.Vector;
import luxe.Color;

class MyPuzzlesCreate extends State
{
    private var background : Visual;

    override public function onenabled<T>(_data : T)
    {
        Luxe.events.fire('myPuzzles.pause', { pause : true });

        background = new Visual({
            pos   : new Vector(0, 0),
            size  : new Vector(Luxe.screen.width, Luxe.screen.height),
            color : new Color(0, 0, 0, 0),
            depth : 7
        });
        background.color.tween(0.25, { a : 0.5 });
    }

    override public function ondisabled<T>(_data : T)
    {
        Luxe.events.fire('myPuzzles.pause', { pause : false });
    }
}
