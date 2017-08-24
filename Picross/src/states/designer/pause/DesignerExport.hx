package states.designer.pause;

import luxe.States;
import luxe.Visual;
import luxe.Input;
import luxe.Text;

using utils.EntityHelper;

class DesignerExport extends State
{
    private var menu : Visual;

    private var listenExport : String;
    private var listenCancel : String;

    override public function init()
    {
        menu = ui.creators.DesignerUI.export();
        menu.pos.set_xy(320, 720);
    }

    override public function onenter<T>(_data : T)
    {
        // Move the popup in and connect event listeners.
        luxe.tween.Actuate.tween(menu.pos, 0.25, { y : 80 }).ease(luxe.tween.easing.Quad.easeInOut);

        listenExport = menu.findChild('bttn_export').events.listen('released', onExportClicked);
        listenCancel = menu.findChild('bttn_cancel').events.listen('released', onCancelClicked);
    }

    override public function onleave<T>(_data : T)
    {
        // Move the popup out and remove event listeners.
        luxe.tween.Actuate.tween(menu.pos, 0.25, { y : 720 }).ease(luxe.tween.easing.Quad.easeInOut);

        menu.findChild('bttn_export').events.unlisten(listenExport);
        menu.findChild('bttn_cancel').events.unlisten(listenCancel);
    }

    override public function ondestroy()
    {
        menu.destroy();
    }

    // Mouse events for the text edit input.
    override public function onmousedown(_event : MouseEvent)
    {
        var mouse = Luxe.camera.screen_point_to_world(_event.pos);

        var panelName : Visual = cast menu.findChild('panel_textedit_name');
        var panelDesc : Visual = cast menu.findChild('panel_textedit_description');
        var editName : Text = cast menu.findChild('textedit_name');
        var editDesc : Text = cast menu.findChild('textedit_description');

        if (editName.has('text_edit')) editName.remove('text_edit');
        if (editDesc.has('text_edit')) editDesc.remove('text_edit');

        if (mouse.pointInside(panelName.transform.world.pos, panelName.size))
        {
            if (!editName.has('text_edit'))
            {
                editName.add(new components.ui.TextEdit());
            }
        }
        if (mouse.pointInside(panelDesc.transform.world.pos, panelDesc.size))
        {
            if (!editDesc.has('text_edit'))
            {
                editDesc.add(new components.ui.TextEdit());
            }
        }
    }

    /**
     *  When export is clicked get the text from the name and description input and fire an event containing them.
     *  @param _ - 
     */
    private function onExportClicked(_)
    {
        var nameInput : Text = cast menu.findChild('textedit_name');
        var descInput : Text = cast menu.findChild('textedit_description');
        Luxe.events.queue('designer.menu.export', { name : nameInput.text, description : descInput.text });

        machine.unset();
    }

    /**
     *  Change back to the pause menu.
     *  @param _ - 
     */
    private function onCancelClicked(_)
    {
        machine.set('menu');
    }
}
