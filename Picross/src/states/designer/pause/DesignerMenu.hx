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
        menu = ui.creators.DesignerUI.menu();
        menu.pos.set_xy(320, -560);
    }

    override public function onenter<T>(_data : T)
    {
        luxe.tween.Actuate.tween(menu.pos, 0.25, { y : 80 }).ease(luxe.tween.easing.Quad.easeInOut);

        listenResume = menu.findChild('bttn_resume').events.listen('clicked', onResumeClicked);
        listenSave   = menu.findChild('bttn_save'  ).events.listen('clicked', onSaveClicked  );
        listenExport = menu.findChild('bttn_export').events.listen('clicked', onExportClicked);
        listenMenu   = menu.findChild('bttn_menu'  ).events.listen('clicked', onMenuClicked  );
    }

    override public function onleave<T>(_data : T)
    {
        luxe.tween.Actuate.tween(menu.pos, 0.25, { y : -560 }).ease(luxe.tween.easing.Quad.easeInOut);

        menu.findChild('bttn_resume').events.unlisten(listenResume);
        menu.findChild('bttn_save'  ).events.unlisten(listenSave);
        menu.findChild('bttn_export').events.unlisten(listenExport);
        menu.findChild('bttn_menu'  ).events.unlisten(listenMenu);
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
        machine.unset();
        Luxe.events.fire('designer.menu.main');
    }    
}
