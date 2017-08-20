package ui;

import luxe.Visual;
import luxe.Color;
import luxe.Vector;
import luxe.NineSlice;
import luxe.Rectangle;
import luxe.Input;
import phoenix.RenderTexture;
import phoenix.Batcher;

using utils.EntityHelper;

class GridView extends Visual
{
    private var targetTexture : RenderTexture;
    private var batcher : Batcher;
    private var background : NineSlice;

    /**
     *  All of the visual entities to be displayed in this grid view.
     */
    public var items : Array<Visual>;

    /**
     *  The number of columns in this grid view.
     */
    public var columns : Int;

    /**
     *  The initial x offset of each item in the grid view.
     */
    public var x_offset : Int;

    /**
     *  The initial y offset of each item in the grid view.
     */
    public var y_offset : Int;

    /**
     *  The x distance between two neighbouring items.
     */
    public var x_sep : Int;

    /**
     *  The y distance between two neighbouring items.
     */
    public var y_sep : Int;

    public function new(_options : GridViewOptions)
    {
        super({});

        pos.set_xy(_options.boundary.x, _options.boundary.y);
        size.set_xy(_options.boundary.w, _options.boundary.h);

        _options.x_offset == null ? x_offset = 0 : x_offset = _options.x_offset;
        _options.y_offset == null ? y_offset = 0 : y_offset = _options.y_offset;
        _options.x_sep == null ? x_sep = 0 : x_sep = _options.x_sep;
        _options.y_sep == null ? y_sep = 0 : y_sep = _options.y_sep;
        _options.items == null ? items = new Array<Visual>() : items = _options.items;

        columns = _options.columns;
    }

    override public function init()
    {
        targetTexture = new RenderTexture({
            id     : 'rtt_listView',
            width  : cast size.x,
            height : cast size.y
        });

        batcher = Luxe.renderer.create_batcher({ name : 'batcher_listView' });
        batcher.view.viewport = new Rectangle(0, 0, size.x, size.y);

        // Add background
        background = new NineSlice({
            name : 'listView_background',
            texture : Luxe.resources.texture('assets/images/ui/roundedPanel.png'),
            top : 20, left : 20, bottom : 20, right : 20,
            color : new Color().rgb(0x333333),
            batcher : batcher
        });
        background.create(new Vector(0, 0), size.x, size.y);

        // Set the position, parent, and bactcher for all of the items in this grid view.
        build();

        // Set the position, size, and texture of the base visual
        geometry = Luxe.draw.texture({
            texture : targetTexture,
            flipy : true
        });

        batcher.on(prerender , before);
        batcher.on(postrender, after);
    }

    /**
     *  Moves all items up or down depending on what way the mouse wheel moved.
     *  @param _event MouseEvent.
     */
    override public function onmousewheel(_event : MouseEvent)
    {
        if (items.length == 0) return;

        // Only scroll if we are over the list.
        var mouse = Luxe.camera.screen_point_to_world(Luxe.screen.cursor.pos);
        if (!mouse.pointInside(pos, size)) return;

        var diff = (_event.y * 10);

        var firstItem = items[0];
        var lastItem = items[items.length - 1];
        if (firstItem.pos.y + diff > pos.y - y_offset) return;
        if (lastItem.pos.y + lastItem.size.y + diff < size.y - y_offset) return;

        for (item in items)
        {
            item.pos.y += diff;
        }

        updateHighlight(mouse.subtract(pos));
    }

    override public function onmousemove(_event : MouseEvent)
    {
        var mouse = Luxe.camera.screen_point_to_world(Luxe.screen.cursor.pos);
        if (!mouse.pointInside(pos, size)) return;

        updateHighlight(mouse.subtract(pos));
    }

    /**
     *  When the left mouse button is pressed check for any overlapping items.
     *  @param _event MouseEvent.
     */
    override public function onmousedown(_event : MouseEvent)
    {
        if (_event.button != left) return;

        var mouse = Luxe.camera.screen_point_to_world(Luxe.screen.cursor.pos);
        if (!mouse.pointInside(pos, size)) return;

        for (i in 0...items.length)
        {
            if (mouse.clone().subtract(pos).pointInside(items[i].pos, items[i].size))
            {
                events.fire('item.clicked', i);
                return;
            }
        }
    }

    /**
     *  Checks for any geometry overlapping and changes its transparency as needed.
     */
    private function updateHighlight(_mouse : Vector)
    {
        for (item in items)
        {
            if (_mouse.pointInside(item.pos, item.size))
            {
                item.color.a = 0.5;
            }
            else
            {
                item.color.a = 1;
            }
        }
    }

    public function build()
    {
        var i = 0;
        var j = 0;

        for (item in items)
        {
            item.parent = background;
            item.pos.set_xy(
                x_offset + (j * item.size.x) + (j * x_sep),
                y_offset + (i * item.size.y) + (i * y_sep)
            );

            batcher.add(item.geometry);
            Luxe.renderer.batcher.remove(item.geometry);

            if (j >= columns -1)
            {
                j = 0;
                i ++;
            }
            else
            {
                j ++;
            }
        }
    }

    private function before(_)
    {
        Luxe.renderer.target = targetTexture;
        Luxe.renderer.clear(new Color(0, 0, 0, 0));
    }

    private function after(_)
    {
        Luxe.renderer.target = null;
    }
}

typedef GridViewOptions = {
    var boundary : Rectangle;
    var columns : Int;
    @:optional var x_offset : Int;
    @:optional var y_offset : Int;
    @:optional var x_sep : Int;
    @:optional var y_sep : Int;
    @:optional var items : Array<Visual>;
}
