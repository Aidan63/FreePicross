package components;

import luxe.Component;
import luxe.Visual;
import luxe.Camera;
import luxe.Color;
import luxe.options.ComponentOptions;

class Flash extends Component
{
    private var time : Float;
    private var visual : Visual;

    public function new(_options : FlashOptions)
    {
        super(_options);

        time = _options.time;
    }

    override public function onadded()
    {
        var camera : Camera = cast entity;
        visual = new Visual({
            color    : new Color(1, 1, 1, 1),
            depth    : 10,
            geometry : Luxe.draw.box({
                x : camera.pos.x,
                y : camera.pos.y,
                w : camera.viewport.w,
                h : camera.viewport.h
            })
        });

        visual.color.tween(time, { a : 0 }).onComplete(function() {
            remove(name);
        });
    }

    override public function onremoved()
    {
        visual.destroy();
    }
}

typedef FlashOptions = {
    > ComponentOptions,
    var time : Float;
}
