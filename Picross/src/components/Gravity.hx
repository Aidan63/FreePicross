package components;

import luxe.Component;
import luxe.Vector;
import luxe.options.ComponentOptions;

class Gravity extends Component
{
    private var value : Float;
    private var velocity : Vector;

    public function new(_options : GravityOptions)
    {
        super(_options);
        value = _options.value;
        velocity = new Vector(_options.ix, _options.iy);
    }

    override public function update(_dt : Float)
    {
        pos.x += velocity.x * _dt;
        pos.y += velocity.y * _dt;

        //velocity.x += value * _dt;
        velocity.y += value * _dt;
    }
}

typedef GravityOptions = {
    > ComponentOptions,
    var value : Float;
    var ix : Float;
    var iy : Float;
}
