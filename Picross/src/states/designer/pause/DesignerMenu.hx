package states.designer.pause;

import luxe.States;
import luxe.Visual;

using utils.EntityHelper;

class DesignerMenu extends State
{
    private var menu : Visual;

    private var listenResume : String;
    private var listenSave : String;
    private var listenExport : String;
    private var listenMenu : String;

    override public function init()
    {
        menu = ui.designer.DesignerUI.menu();
        menu.pos.set_xy(320, -560);
    }

    override public function onenter<T>(_data : T)
    {
        luxe.tween.Actuate.tween(menu.pos, 0.25, { y : 80 }).ease(luxe.tween.easing.Quad.easeInOut);

        listenResume = menu.findChild('ui_designer_menu_bttnResume').events.listen('clicked', onResumeClicked);
        listenSave   = menu.findChild('ui_designer_menu_bttnSave'  ).events.listen('clicked', onSaveClicked  );
        listenExport = menu.findChild('ui_designer_menu_bttnExport').events.listen('clicked', onExportClicked);
        listenMenu   = menu.findChild('ui_designer_menu_bttnMenu'  ).events.listen('clicked', onMenuClicked  );
    }

    override public function onleave<T>(_data : T)
    {
        luxe.tween.Actuate.tween(menu.pos, 0.25, { y : -560 }).ease(luxe.tween.easing.Quad.easeInOut);

        menu.findChild('ui_designer_menu_bttnResume').events.unlisten(listenResume);
        menu.findChild('ui_designer_menu_bttnSave'  ).events.unlisten(listenSave);
        menu.findChild('ui_designer_menu_bttnExport').events.unlisten(listenExport);
        menu.findChild('ui_designer_menu_bttnMenu'  ).events.unlisten(listenMenu);
    }

    override public function ondestroy()
    {
        menu.destroy();
    }

    private function onResumeClicked(_)
    {
        machine.unset();
        Luxe.events.fire('designer.menu.resume');
    }
    private function onSaveClicked(_)
    {
        //
    }
    private function onExportClicked(_)
    {
        machine.set('export');
    }
    private function onMenuClicked(_)
    {
        //
    }    
}
