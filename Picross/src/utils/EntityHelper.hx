package utils;

import luxe.Entity;
import luxe.Vector;

class EntityHelper
{
    public static function findChild(_entity : Entity, _name : String) : Entity
    {
        for (child in _entity.children)
        {
            if (child.name == _name) return child;
        }

        return null;
    }

    public static function pointInside(_point : Vector, _pos : Vector, _size) : Bool
    {
        return (_point.x > _pos.x && _point.y > _pos.y && _point.x < _pos.x + _size.x && _point.y < _pos.y + _size.y);
    }
}