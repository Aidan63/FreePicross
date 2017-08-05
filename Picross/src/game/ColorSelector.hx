package game;

import luxe.Color;

class ColorSelector
{
    /**
     *  The current colour selected in the puzzle.
     */
    public var currentColor : ColorTypes;

    /**
     *  Map of colours onto luxe colour types.
     */
    public var colors : Map<ColorTypes, Color>;

    public function new()
    {
        currentColor = ColorTypes.Primary;
        colors = [
            ColorTypes.Primary   => new Color().rgb(0x3083ff),
            ColorTypes.Secondary => new Color().rgb(0xff9f16),
        ];
    }

    public function getLuxeColor() : Color
    {
        return colors[currentColor].clone();
    }
}

enum ColorTypes {
    Primary;
    Secondary;
}
