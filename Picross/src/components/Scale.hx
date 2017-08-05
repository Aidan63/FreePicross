package components;

import luxe.Component;
import luxe.Vector;
import luxe.Visual;
import luxe.options.ComponentOptions;

class Scale extends Component
{
    /**
     *  The target size in pixels of the tween.
     */
    var targetSize : Vector;

    /**
     *  The x target scale of the tween.
     */
    var xScale : Float;

    /**
     *  The y target scale of the tween.
     */
    var yScale : Float;

    /**
     *  The time it takes to complete the tween
     */
    var time : Float;

    public function new(_options : ScaleOptions)
    {
        super(_options);

        if (_options.factor == null)
        {
            targetSize = new Vector(0, 0);
            if (_options.targetW != null) targetSize.x = _options.targetW;
            if (_options.targetH != null) targetSize.y = _options.targetH;
        }
        else
        {
            xScale = _options.factor;
            yScale = _options.factor;
        }

        time   = _options.time;
    }

    override public function onadded()
    {
        var visual : Visual = cast entity;
        if (targetSize != null)
        {
            xScale = (visual.size.x + targetSize.x) / visual.size.x;
            yScale = (visual.size.y + targetSize.y) / visual.size.y;
        }
        
        luxe.tween.Actuate.tween(scale, time, { x : xScale, y : yScale });
    }

    override public function onremoved()
    {
        luxe.tween.Actuate.stop(scale);
    }
}

typedef ScaleOptions = {
    > ComponentOptions,
    var time  : Float;
    @:optional var factor : Float;
    @:optional var targetW : Float;
    @:optional var targetH : Float;
}
