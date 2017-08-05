package components;

import luxe.Component;
import luxe.Visual;
import luxe.options.ComponentOptions;

class Flicker extends Component
{
    /**
     *  The flicker interval.
     */
    private var interval : Float;

    /**
     *  The delay time until the flickering starts.
     */
    private var delay : Float;

    /**
     *  The timer until the flickering starts.
     */
    private var delayTimer : snow.api.Timer;

    /**
     *  The snow api time used to change the visuals alpha.
     */
    private var timer : snow.api.Timer;

    /**
     *  The visual class cast from the entity.
     */
    private var visual : Visual;

    /**
     *  The first alpha value of the flicker.
     */
    private var alpha1 : Float;

    /**
     *  The second alpha value of the flicker.
     */
    private var alpha2 : Float;

    public function new(_options : FlickerOptions)
    {
        super(_options);
        interval = _options.interval;

        _options.delay  == null ? delay  = 0 : delay  = _options.delay;
        _options.alpha1 == null ? alpha1 = 1 : alpha1 = _options.alpha1;
        _options.alpha2 == null ? alpha2 = 0 : alpha2 = _options.alpha2;
    }

    override public function onadded()
    {
        visual = cast entity;
        visual.color.a = alpha1;

        delayTimer = Luxe.timer.schedule(delay, onFlickerStart);
    }

    override public function onremoved()
    {
        timer.stop();
    }

    private function onFlickerStart()
    {
        timer = Luxe.timer.schedule(interval, onFlicker, true);
    }

    private function onFlicker()
    {
        visual.color.a == alpha1 ? visual.color.a = alpha2 : visual.color.a = alpha1;
    }
}

typedef FlickerOptions = {
    > ComponentOptions,
    var interval : Float;
    @:optional var delay : Float;
    @:optional var alpha1 : Float;
    @:optional var alpha2 : Float;
}
