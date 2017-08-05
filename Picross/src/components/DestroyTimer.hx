package components;

import luxe.Component;
import luxe.options.ComponentOptions;

class DestroyTimer extends Component
{
    private var delay : Float;
    private var timer : snow.api.Timer;

    public function new(_options : DestroyTimerOptions)
    {
        super(_options);

        delay = _options.delay;
    }

    override public function onadded()
    {
        timer = Luxe.timer.schedule(delay, onDestroyTimer, false);
    }

    override public function onremoved()
    {
        timer.stop();
    }

    private function onDestroyTimer()
    {
        entity.destroy();
    }
}

typedef DestroyTimerOptions = {
    > ComponentOptions,
    var delay : Float;
}
