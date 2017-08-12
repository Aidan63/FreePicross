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

    /**
     *  The colour for the designer.
     */
    public var designerColor : Color;

    public function new()
    {
        currentColor = ColorTypes.Primary;
        designerColor = new Color(0, 0, 0, 1);
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
