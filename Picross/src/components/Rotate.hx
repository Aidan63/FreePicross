package components;

import luxe.Component;
import luxe.Visual;
import luxe.options.ComponentOptions;

class Rotate extends Component
{
    var speed : Float;
    var visual : Visual;

    public function new(_options : RotateOptions)
    {
        super(_options);
        speed = _options.speed;
    }

    override public function onadded()
    {
        visual = cast entity;
    }

    override public function update(_dt : Float)
    {
        visual.rotation_z += speed * _dt;
    }
}

typedef RotateOptions = {
    > ComponentOptions,
    var speed : Float;
}
