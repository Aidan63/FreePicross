package utils;

import luxe.Entity;

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
}