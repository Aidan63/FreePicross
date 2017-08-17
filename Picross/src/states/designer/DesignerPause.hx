package states.designer;

import luxe.States;
import luxe.Visual;
import luxe.Color;
import luxe.Vector;

class DesignerPause extends State
{
    private var background : Visual;
    private var fsm : States;

    private var listenMenuResume : String;
    private var listenMenuMain : String;
    private var listenMenuExport : String;

    override public function onenabled<T>(_data : T)
    {
        Luxe.events.fire('designer.pause', { state : true });

        listenMenuResume = Luxe.events.listen('designer.menu.resume', onResumeClicked);
        listenMenuMain   = Luxe.events.listen('designer.menu.main'  , onMenuClicked);
        listenMenuExport = Luxe.events.listen('designer.menu.export', onExportClicked);

        fsm = new States({ name : 'designer_pause_states' });
        fsm.add(new states.designer.pause.DesignerMenu({ name : 'menu' }));
        fsm.add(new states.designer.pause.DesignerExport({ name : 'export' }));
        fsm.set('menu');

        background = new Visual({
            pos   : new Vector(0, 0),
            size  : new Vector(Luxe.screen.width, Luxe.screen.height),
            color : new Color(0, 0, 0, 0),
            depth : 5
        });
        background.color.tween(0.25, { a : 0.5 });
    }

    override public function ondisabled<T>(_data : T)
    {
        Luxe.events.unlisten(listenMenuResume);
        Luxe.events.unlisten(listenMenuMain);
        Luxe.events.unlisten(listenMenuExport);

        background.color.tween(0.25, { a : 0 });

        // Wait until the background has faded out then fire the events to unpause and remove stuff.
        Luxe.timer.schedule(0.25, function() {
            fsm.destroy();
            background.destroy();

            Luxe.events.fire('designer.pause', { state : false });
        });
    }

    /**
     *  Export popup events.
     */

    private function onResumeClicked(_)
    {
        machine.disable('designer_pause');
    }

    private function onMenuClicked(_)
    {
        machine.disable('designer_pause');
        Luxe.timer.schedule(0.25, function() {
            machine.set('designer_list');
        });
    }

    private function onExportClicked(_event : { _name : String, _description : String})
    {
        Luxe.events.fire('designer.export', _event);
        onMenuClicked(null);
    }
}
