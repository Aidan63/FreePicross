package components;

import luxe.Component;
import luxe.Vector;
import luxe.options.ComponentOptions;
import luxe.tween.easing.IEasing;

class Slider extends Component
{
    /**
     *  The end position of the entity.
     */
    private var end : Vector;

    /**
     *  The time it takes to complete the movement.
     */
    private var time : Float;

    /**
     *  The time in seconds until the slide begins.
     */
    private var delay : Float;

    /**
     *  The ease type for this slide.
     */
    private var ease : IEasing;

    public function new(_options : SliderOptions)
    {
        super(_options);

        end  = _options.end;
        time = _options.time;
        
        _options.delay == null ? delay = 0 : delay = _options.delay;
        _options.ease  == null ? ease  = luxe.tween.easing.Linear.easeNone : ease = _options.ease;
    }

    override public function onadded()
    {
        luxe.tween.Actuate.tween(pos, time, { x : end.x, y : end.y }).ease(ease).delay(delay).onComplete(function() {
            remove(name);
        });
    }

    override public function onremoved()
    {
        luxe.tween.Actuate.stop(entity.pos);
    }
}

typedef SliderOptions = {
    > ComponentOptions,
    var end : Vector;
    var time : Float;
    @:optional var delay : Float;
    @:optional var ease : IEasing;
}
