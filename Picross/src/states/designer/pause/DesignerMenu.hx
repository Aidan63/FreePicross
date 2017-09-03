package states.designer.pause;

import luxe.States;
import luxe.Visual;
import luxe.tween.Actuate;
import luxe.tween.easing.Quad;

using utils.EntityHelper;

class DesignerMenu extends State
{
    private var menu : Visual;

    private var listenResume : String;
    private var listenSave : String;
    private var listenExport : String;
    private var listenMenu : String;

    private var background : Visual;

    override public function init()
    {
        menu = ui.creators.DesignerUI.menu();
        menu.pos.set_xy(320, -560);
    }

    override public function onenter<T>(_data : T)
    {
        Luxe.events.fire('designer.pause', { state : true });

        if (_data != null)
        {
            background = cast _data;
            background.color.tween(0.25, { a : 0.5 });
        }

        Actuate.tween(menu.pos, 0.25, { y : 80 }).ease(Quad.easeInOut);

        listenResume = menu.findChild('bttn_resume').events.listen('released', onResumeClicked);
        listenSave   = menu.findChild('bttn_save'  ).events.listen('released', onSaveClicked  );
        listenExport = menu.findChild('bttn_export').events.listen('released', onExportClicked);
        listenMenu   = menu.findChild('bttn_menu'  ).events.listen('released', onMenuClicked  );
    }

    override public function onleave<T>(_data : T)
    {
        Actuate.tween(menu.pos, 0.25, { y : -560 }).ease(Quad.easeInOut);

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
        if (background != null) background.color.tween(0.25, { a : 0 });
        Luxe.events.fire('designer.pause', { state : false });

        machine.unset(true);
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
        Luxe.events.fire('designer.exit');
    }    
}
