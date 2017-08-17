package states.designer.pause;

import luxe.States;
import luxe.Visual;

using utils.EntityHelper;

class DesignerExport extends State
{
    private var menu : Visual;

    private var listenExport : String;
    private var listenCancel : String;

    override public function init()
    {
        menu = ui.designer.DesignerUI.export();
        menu.pos.set_xy(320, 720);
    }

    override public function onenter<T>(_data : T)
    {
        luxe.tween.Actuate.tween(menu.pos, 0.25, { y : 80 }).ease(luxe.tween.easing.Quad.easeInOut);

        listenExport = menu.findChild('ui_designer_export_bttnExport').events.listen('clicked', onExportClicked);
        listenCancel = menu.findChild('ui_designer_export_bttnCancel').events.listen('clicked', onCancelClicked);
    }

    override public function onleave<T>(_data : T)
    {
        luxe.tween.Actuate.tween(menu.pos, 0.25, { y : 720 }).ease(luxe.tween.easing.Quad.easeInOut);

        menu.findChild('ui_designer_export_bttnExport').events.unlisten(listenExport);
        menu.findChild('ui_designer_export_bttnCancel').events.unlisten(listenCancel);
    }

    override public function ondestroy()
    {
        menu.destroy();
    }
    private function onExportClicked(_)
    {
        var nameInput : ui.TextInput = cast menu.findChild('ui_designer_export_inputName');
        var descInput : ui.TextInput = cast menu.findChild('ui_designer_export_inputDescription');
        Luxe.events.queue('designer.menu.export', { name : nameInput.text, description : descInput.text });

        machine.unset();
    }
    private function onCancelClicked(_)
    {
        machine.set('menu');
    }
}
