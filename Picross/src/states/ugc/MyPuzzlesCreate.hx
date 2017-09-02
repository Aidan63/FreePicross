package states.ugc;

import luxe.States;
import luxe.Visual;
import luxe.Input;
import luxe.Vector;
import luxe.Color;
import luxe.Text;
import luxe.tween.Actuate;
import components.ui.TextEdit;
using utils.EntityHelper;

class MyPuzzlesCreate extends State
{
    private var background : Visual;
    private var popup : Visual;

    private var regFilter : EReg;

    private var listenCreateClicked : String;
    private var listenCancelClicked : String;

    override public function init()
    {
        background = new Visual({
            pos   : new Vector(0, 0),
            size  : new Vector(Luxe.screen.width, Luxe.screen.height),
            color : new Color(0, 0, 0, 0),
            depth : 7
        });

        popup = ui.creators.MyPuzzles.newPuzzlePopup();
        popup.pos.set_xy(300, -500);

        regFilter = new EReg('[0-9]+','gi');
    }

    override public function onenter<T>(_data : T)
    {
        Luxe.events.fire('myPuzzles.pause', { pause : true });

        // Fade in a semi transparent black background.
        background.color.tween(0.25, { a : 0.5 });

        // Create the popup ui and move it in.
        Actuate.tween(popup.pos, 0.25, { y : 120 });

        // Connect event listeners.
        listenCreateClicked = popup.findChild('bttn_create').events.listen('clicked', onCreateClicked);
        listenCancelClicked = popup.findChild('bttn_cancel').events.listen('clicked', onCancelClicked);
    }

    override public function onleave<T>(_data : T)
    {
        background.color.tween(0.25, { a : 0 });
        Actuate.tween(popup.pos, 0.25, { y : -500 });

        popup.findChild('bttn_create').events.unlisten(listenCreateClicked);
        popup.findChild('bttn_cancel').events.unlisten(listenCancelClicked);

        Luxe.events.fire('myPuzzles.pause', { pause : false });
    }

    override public function ondestroy()
    {
        Actuate.stop(background.color);
        Actuate.stop(popup.pos);

        popup.destroy();
        background.destroy();

        popup = null;
        background = null;
    }

    /**
     *  Removes / adds text edit components to the popups width and height text.
     *  @param _event - MouseEvent
     */
    override public function onmousedown(_event : MouseEvent)
    {
        var mouse = Luxe.camera.screen_point_to_world(_event.pos);

        var rowsPanel : Visual = cast popup.findChild('panel_rows');
        var colsPanel : Visual = cast popup.findChild('panel_columns');
        var editRows = popup.findChild('textentry_rows');
        var editCols = popup.findChild('textentry_columns');

        if (editRows.has('text_edit')) editRows.remove('text_edit');
        if (editCols.has('text_edit')) editCols.remove('text_edit');

        if (mouse.pointInside(rowsPanel.transform.world.pos, rowsPanel.size))
        {
            if (!editRows.has('text_edit'))
            {
                editRows.add(new TextEdit({ filter:regFilter }));
            }
        }
        if (mouse.pointInside(colsPanel.transform.world.pos, colsPanel.size))
        {
            if (!editCols.has('text_edit'))
            {
                editCols.add(new TextEdit({ filter:regFilter }));
            }
        }
    }

    override public function onmousemove(_event : MouseEvent)
    {
        var mouse = Luxe.camera.screen_point_to_world(_event.pos);

        var panelRows : Visual = cast popup.findChild('panel_rows');
        var panelCols : Visual = cast popup.findChild('panel_columns');

        panelRows.color.a = 1;
        panelCols.color.a = 1;

        if (mouse.pointInside(panelRows.transform.world.pos, panelRows.size))
        {
            panelRows.color.a = 0.5;
        }
        if (mouse.pointInside(panelCols.transform.world.pos, panelCols.size))
        {
            panelCols.color.a = 0.5;
        }
    }

    /**
     *  Called when the user presses the create button.
     *  Converts the numbers from a string to int and clamps them between a range.
     *  @param _ - 
     */
    private function onCreateClicked(_)
    {
        var editRows : Text = cast popup.findChild('textentry_rows');
        var editCols : Text = cast popup.findChild('textentry_columns');

        var rows : Int = Std.int(luxe.utils.Maths.clamp(Std.parseInt(editRows.text), 1, 32));
        var cols : Int = Std.int(luxe.utils.Maths.clamp(Std.parseInt(editCols.text), 1, 32));
        
        Luxe.events.queue('myPuzzles.create', new data.events.PuzzleSize(rows, cols));
    }
    private function onCancelClicked(_)
    {
        machine.unset();
    }
}
