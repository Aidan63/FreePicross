package ui;

import luxe.Text;
import luxe.Visual;
import luxe.Rectangle;
import luxe.NineSlice;
import luxe.Vector;
import luxe.Color;
import luxe.Input;
import luxe.options.NineSliceOptions;

enum ButtonState {
    None;
    Hover;
    Clicked;
}

class Button extends NineSlice
{
    /**
     *  The string this button will display.
     */
    public var label : Visual;

    /**
     *  The colour of the label in each button state.
     */
    public var labelColors : Array<Color>;

    /**
     *  The position of the label in each button state.
     */
    public var labelOffsets : Array<Vector>;

    /**
     *  The UV positions for the button in each state.
     */
    public var textureUVs : Array<Rectangle>;

    /**
     *  The UV color for the button in each state.
     */
    public var textureColors : Array<Color>;

    private var textObject : Text;
    private var state : ButtonState;
    private var verts : Array<Vector>;

    public function new(_options : ButtonOptions)
    {
        super(_options);

        _options.labelColors   == null ? labelColors   = [ new Color() , new Color() , new Color()  ] : labelColors   = _options.labelColors;
        _options.labelOffsets  == null ? labelOffsets  = [ new Vector(), new Vector(), new Vector() ] : labelOffsets  = _options.labelOffsets;
        _options.textureColors == null ? textureColors = [ new Color() , new Color() , new Color()  ] : textureColors = _options.textureColors;
        _options.textureUVs    == null ? textureUVs    = [
            new Rectangle(0, 0, texture.width, texture.height),
            new Rectangle(0, 0, texture.width, texture.height),
            new Rectangle(0, 0, texture.width, texture.height)
        ] : textureUVs = _options.textureUVs;

        state = None;
        verts = [ new Vector(0, 0), new Vector(size.x, 0), new Vector(size.x, size.y), new Vector(0, size.y) ];

        // Set offsets for the initial button state.
        source_x = textureUVs[0].x;
        source_y = textureUVs[0].y;
        source_w = textureUVs[0].w;
        source_h = textureUVs[0].h;
        color = textureColors[0];

        create(pos, size.x, size.y, true);

        label = _options.label;
        if (label != null)
        {
            label.parent = this;
            label.color  = labelColors[0];
            label.pos    = labelOffsets[0];
        }
    }

    override public function ondestroy()
    {
        if (label != null) label.destroy();
    }

    override public function onmousedown(_event : MouseEvent)
    {
        var mouse : Vector = Luxe.camera.screen_point_to_world(_event.pos);
        if (Luxe.utils.geometry.point_in_polygon(mouse, pos, verts))
        {
            source_x = textureUVs[2].x;
            source_y = textureUVs[2].y;
            source_w = textureUVs[2].w;
            source_h = textureUVs[2].h;
            color = textureColors[2];

            setLabel(2);

            create(pos, size.x, size.y, true);
            state = Clicked;
        }
    }

    override public function onmousemove(_event : MouseEvent)
    {
        var mouse : Vector = Luxe.camera.screen_point_to_world(_event.pos);
        if (Luxe.utils.geometry.point_in_polygon(mouse, pos, verts))
        {
            if (state == Hover || state == Clicked) return;

            source_x = textureUVs[1].x;
            source_y = textureUVs[1].y;
            source_w = textureUVs[1].w;
            source_h = textureUVs[1].h;
            color = textureColors[1];

            setLabel(1);

            create(pos, size.x, size.y, true);
            state = Hover;
        }
        else
        {
            if (state == None) return;

            source_x = textureUVs[0].x;
            source_y = textureUVs[0].y;
            source_w = textureUVs[0].w;
            source_h = textureUVs[0].h;
            color = textureColors[0];

            setLabel(0);

            create(pos, size.x, size.y, true);
            state = None;
        }
    }

    override public function onmouseup(_event : MouseEvent)
    {
        if (state == Clicked)
        {
            events.fire('clicked');

            source_x = textureUVs[1].x;
            source_y = textureUVs[1].y;
            source_w = textureUVs[1].w;
            source_h = textureUVs[1].h;
            color = textureColors[1];

            setLabel(1);

            create(pos, size.x, size.y, true);
            state = Hover;
        }
    }

    private function setLabel(_int : Int)
    {
        if (label == null) return;
        label.pos   = labelOffsets[_int];
        label.color = labelColors[_int];
    }
}

typedef ButtonOptions = {
    > NineSliceOptions,
    @:optional var label : Visual;
    @:optional var labelColors   : Array<Color>;
    @:optional var labelOffsets  : Array<Vector>;
    @:optional var textureUVs    : Array<Rectangle>;
    @:optional var textureColors : Array<Color>;
}
