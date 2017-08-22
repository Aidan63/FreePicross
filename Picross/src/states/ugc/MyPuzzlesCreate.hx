package states.ugc;

import luxe.States;
import luxe.Visual;
import luxe.Input;
import luxe.Vector;
import luxe.Color;
import components.ui.TextEdit;
using utils.EntityHelper;

class MyPuzzlesCreate extends State
{
    private var background : Visual;
    private var popup : Visual;

    private var regFilter : EReg;

    private var listenCreateClicked : String;
    private var listenCancelClicked : String;

    override public function onenabled<T>(_data : T)
    {
        Luxe.events.fire('myPuzzles.pause', { pause : true });

        // Fade in a semi transparent black background.
        background = new Visual({
            pos   : new Vector(0, 0),
            size  : new Vector(Luxe.screen.width, Luxe.screen.height),
            color : new Color(0, 0, 0, 0),
            depth : 7
        });
        background.color.tween(0.25, { a : 0.5 });

        // Create the popup ui and move it in.
        popup = ui.creators.MyPuzzles.newPuzzlePopup();
        popup.pos.set_xy(300, -500);
        luxe.tween.Actuate.tween(popup.pos, 0.25, { y : 120 });

        regFilter = new EReg('[0-9]+','gi');

        // Connect event listeners.
        listenCreateClicked = popup.findChild('bttn_create').events.listen('clicked', onCreateClicked);
        listenCancelClicked = popup.findChild('bttn_cancel').events.listen('clicked', onCancelClicked);
    }

    override public function ondisabled<T>(_data : T)
    {
        popup.findChild('bttn_create').events.unlisten(listenCreateClicked);
        popup.findChild('bttn_cancel').events.unlisten(listenCancelClicked);

        popup.destroy();
        background.destroy();

        Luxe.events.fire('myPuzzles.pause', { pause : false });
    }

    /**
     *  Removes / adds text edit components to the popups width and height text.
     *  @param _event - MouseEvent
     */
    override public function onmousedown(_event : MouseEvent)
    {
        var mouse = Luxe.camera.screen_point_to_world(_event.pos);

        var widthPanel  : Visual = cast popup.findChild('panel_width');
        var heightPanel : Visual = cast popup.findChild('panel_height');
        var editWidth  = popup.findChild('textentry_width');
        var editHeight = popup.findChild('textentry_height');

        if (editWidth.has('text_edit')) editWidth.remove('text_edit');
        if (editHeight.has('text_edit')) editHeight.remove('text_edit');

        if (mouse.pointInside(widthPanel.transform.world.pos, widthPanel.size))
        {
            if (!editWidth.has('text_edit'))
            {
                editWidth.add(new TextEdit({ filter:regFilter }));
            }
        }
        if (mouse.pointInside(heightPanel.transform.world.pos, heightPanel.size))
        {
            if (!editHeight.has('text_edit'))
            {
                editHeight.add(new TextEdit({ filter:regFilter }));
            }
        }
    }

    override public function onmousemove(_event : MouseEvent)
    {
        var mouse = Luxe.camera.screen_point_to_world(_event.pos);

        var widthPanel  : Visual = cast popup.findChild('panel_width');
        var heightPanel : Visual = cast popup.findChild('panel_height');

        widthPanel.color.a = 1;
        heightPanel.color.a = 1;

        if (mouse.pointInside(widthPanel.transform.world.pos, widthPanel.size))
        {
            widthPanel.color.a = 0.5;
        }
        if (mouse.pointInside(heightPanel.transform.world.pos, heightPanel.size))
        {
            heightPanel.color.a = 0.5;
        }
    }

    private function onCreateClicked(_)
    {
        trace('Create clicked');
        Luxe.events.fire('myPuzzles.create');
    }
    private function onCancelClicked(_)
    {
        popup.findChild('bttn_create').active = false;
        popup.findChild('bttn_cancel').active = false;

        background.color.tween(0.25, { a : 0 });
        luxe.tween.Actuate.tween(popup.pos, 0.25, { y : -500 });

        Luxe.timer.schedule(0.25, function() {
            disable();
        });
    }
}
