package ui;

import luxe.NineSlice;
import luxe.Text;
import luxe.Vector;
import luxe.Input;
import luxe.Color;
import luxe.options.NineSliceOptions;
import luxe.options.TextOptions;
using utils.EntityHelper;

class TextInput extends NineSlice
{
    /**
     *  The text string of this text input.
     */
    public var text(get, set) : String;

    private var textObject : Text;
    private var enabled : Bool;
    private var colors : Array<Color>;
    private var maxLength : Int;

    public function new(_options : TextInputOptions)
    {
        super(_options.background);

        transform.world.auto_decompose = true;

        _options.colors == null ? colors = [ new Color(), new Color() ] : colors = _options.colors;
        color = colors[0];

        create(pos, size.x, size.y);
        enabled = false;
        maxLength = 32;

        _options.text.parent = this;
        textObject = new Text(_options.text);
    }

    function get_text() : String
    {
        return textObject.text;
    }
    function set_text(_text : String) : String
    {
        return textObject.text = _text;
    }

    override public function onmousemove(_event : MouseEvent)
    {
        var mouse : Vector = Luxe.camera.screen_point_to_world(_event.pos);
        if (mouse.pointInside(transform.world.pos, size))
        {
            enabled = true;
            color = colors[1];
        }
        else
        {
            enabled = false;
            color = colors[0];
        }
    }

    override public function onkeydown(_event : KeyEvent)
    {
        if (!enabled) return;

        if (_event.keycode == Key.backspace)
        {
            if (text.length > 0)
            {
                text = text.substr(0, text.length - 1);
            }
        }
        if ((_event.keycode >= 97 && _event.keycode <= 122) || _event.keycode == 32)
        {
            if (text.length < maxLength)
            {
                text += String.fromCharCode(_event.keycode);
            }
        }
    }
}

typedef TextInputOptions = {
    var background : NineSliceOptions;
    var text : TextOptions;
    @:optional var colors : Array<Color>;
}
