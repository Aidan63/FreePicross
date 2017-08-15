package components.ui;

import luxe.Component;
import luxe.Input;
import luxe.Text;

class Input extends Component
{
    public var string : String;

    private var maxLength : Int;
    private var text : Text;

    override public function onadded()
    {
        string = '';
        maxLength = 32;

        text = cast entity;
    }

    override public function onkeydown(_event : KeyEvent)
    {
        if (_event.keycode == Key.backspace)
        {
            if (string.length > 0)
            {
                string = string.substr(0, string.length - 1);
                text.text = string;
            }
        }
        if ((_event.keycode >= 97 && _event.keycode <= 122) || _event.keycode == 32)
        {
            if (string.length < maxLength)
            {
                string += String.fromCharCode(_event.keycode);
                text.text = string;
            }
        }
    }
}
