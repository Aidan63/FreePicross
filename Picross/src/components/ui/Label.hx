package components.ui;

import luxe.Visual;
import luxe.Component;
import luxe.Vector;
import luxe.Color;
import luxe.Text;
import luxe.Log.def;
import luxe.options.TextOptions;

class Label extends Component
{
    private var visual : Visual;
    private var label : Text;

    private var colors : Array<Color>;
    private var offsets : Array<Vector>;
    private var textOptions : TextOptions;

    private var listenMouseOver : String;
    private var listenMouseOut : String;
    private var listenMouseClicked : String;
    private var listenMouseReleased : String;
    
    /**
     *  Non physical field to get and set the labels text.
     */
    public var text(get, set) : String;

    public function new(_options : LabelOptions)
    {
        super(_options);
        colors  = def(_options.colors , [ new Color() , new Color() , new Color()  ]);
        offsets = def(_options.offsets, [ new Vector(), new Vector(), new Vector() ]);
        textOptions = _options;
    }

    override public function onadded()
    {
        visual = cast entity;

        textOptions.parent = visual;
        textOptions.name = 'label';
        label = new Text(textOptions);

        label.pos   = offsets[0];
        label.color = colors[0];

        listenMouseOver     = visual.events.listen('over', onMouseOver);
        listenMouseOut      = visual.events.listen('out', onMouseOut);
        listenMouseClicked  = visual.events.listen('clicked', onMouseClicked);
        listenMouseReleased = visual.events.listen('released', onMouseReleased);
    }

    override public function onremoved()
    {
        label.destroy();

        visual.events.unlisten(listenMouseOver);
        visual.events.unlisten(listenMouseOut);
        visual.events.unlisten(listenMouseClicked);
        visual.events.unlisten(listenMouseReleased);
    }

    public function get_text() : String
    {
        return label.text;
    }
    public function set_text(_text : String) : String
    {
        return label.text = _text;
    }

    private function onMouseOver(_)
    {
        label.pos   = offsets[1];
        label.color = colors[1];
    }
    private function onMouseOut(_)
    {
        label.pos   = offsets[0];
        label.color = colors[0];
    }
    private function onMouseClicked(_)
    {
        label.pos   = offsets[2];
        label.color = colors[2];
    }
    private function onMouseReleased(_event : { state : Int })
    {
        if (_event.state == 0)
        {
            // State 0 == None
            label.pos   = offsets[0];
            label.color = colors[0];
        }
        else
        {
            // Else it will be State 1 == Hover
            label.pos   = offsets[1];
            label.color = colors[1];
        }
    }
}

typedef LabelOptions = {
    > TextOptions,
    var name : String;
    @:optional var offsets : Array<Vector>;
    @:optional var colors : Array<Color>;
}
