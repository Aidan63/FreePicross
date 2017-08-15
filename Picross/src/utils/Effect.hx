package utils;

import luxe.Entity;
import luxe.Vector;
import luxe.Visual;

class Effect
{
    public static function select(_pos : Vector, _size : Vector, _expansion : Vector, ?_parent : Entity = null) : Visual
    {
        var ent = new luxe.Visual({
            parent : _parent,
            pos    : _pos.add_xyz(_size.x / 2, _size.y / 2),
            size   : _size,
            origin : _size.clone().subtract_xyz(_size.x / 2, _size.y / 2),
            depth  : 10
        });

        ent.add(new components.AlphaFade({ name : 'fade_in' , time : 0.1, startAlpha : 0, endAlpha : 1 }));
        ent.add(new components.AlphaFade({ name : 'fade_out', time : 0.2, delay : 0.1, startAlpha : 1, endAlpha : 0 }));
        ent.add(new components.Scale({ name : 'scale', time : 0.1, targetW : _expansion.x, targetH : _expansion.y }));
        ent.add(new components.DestroyTimer({ name : 'destroy', delay : 0.4 }));

        return ent;
    }
}
