package components;

import luxe.Component;
import luxe.Visual;
import luxe.options.ComponentOptions;

class AlphaFade extends Component
{
    /**
     *  The time it takes to complete the fade.
     */
    private var time : Float;

    /**
     *  The delay until the tween starts.
     */
    private var delay : Float;

    /**
     *  The initial alpha of the entity.
     */
    private var startAlpha : Float;

    /**
     *  The end alpha of the entity.
     */
    private var endAlpha : Float;

    /**
     *  This components entity cast to a visual type.
     */
    private var visual : Visual;

    /**
     *  The variable which will be tweened and used to set the colours alpha.
     */
    public var alpha : Float;

    /**
     *  The delay timer created.
     */
    public var timer : snow.api.Timer;

    public function new(_options : AlphaFadeOptions)
    {
        super(_options);

        time = _options.time;
        _options.delay      == null ? delay      = 0 : delay      = _options.delay;
        _options.startAlpha == null ? startAlpha = 0 : startAlpha = _options.startAlpha;
        _options.endAlpha   == null ? endAlpha   = 1 : endAlpha   = _options.endAlpha;

        alpha = 0;
    }

    override public function onadded()
    {
        visual = cast entity;

        timer = Luxe.timer.schedule(delay, function() {
            alpha = startAlpha;
            luxe.tween.Actuate.tween(this, time, { alpha : endAlpha }).onUpdate(function() {
                visual.color.a = alpha;
            });
        });
    }

    override public function onremoved()
    {
        timer.stop();
        luxe.tween.Actuate.stop(this);
    }
}

typedef AlphaFadeOptions = {
    > ComponentOptions,
    var time : Float;
    @:optional var delay : Float;
    @:optional var startAlpha : Float;
    @:optional var endAlpha : Float;
}
