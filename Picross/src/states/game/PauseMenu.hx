package states.game;

import luxe.States;
import luxe.Visual;
import luxe.Color;
import luxe.Vector;
import luxe.tween.Actuate;

using utils.EntityHelper;

class PauseMenu extends State
{
    private var menu : Visual;
    private var background : Visual;

    private var listenBttnResume : String;
    private var listenBttnOptions : String;
    private var listenBttnRestart : String;
    private var listenBttnMenu : String;

    override public function init()
    {
        background = new Visual({
            pos   : new Vector(0, 0),
            size  : new Vector(1280, 720),
            color : new Color(0, 0, 0, 0),
            depth : 7
        });
        menu = ui.creators.Game.createPauseRoot();
        menu.pos.set_xy(320, -560);
    }

    override public function onenter<T>(_data : T)
    {
        // If True is provided when entering the game has just been paused.
        // So we fire the game pause event and fade in the black background.
        if (_data != null && cast(_data, Bool))
        {
            Luxe.events.fire('puzzle.pause', { state : true });
            background.color.tween(0.25, { a : 0.5 });
        }

        Actuate.tween(menu.pos, 0.25, { y : 80 });

        listenBttnResume  = menu.findChild('bttn_resume' ).events.listen('released', onBttnResume);
        listenBttnOptions = menu.findChild('bttn_options').events.listen('released', onBttnOptions);
        listenBttnRestart = menu.findChild('bttn_restart').events.listen('released', onBttnRestart);
        listenBttnMenu    = menu.findChild('bttn_menu'   ).events.listen('released', onBttnMenu);
    }

    override public function onleave<T>(_data : T)
    {
        Actuate.tween(menu.pos, 0.25, { y : -560 });

        menu.findChild('bttn_resume' ).events.unlisten(listenBttnResume);
        menu.findChild('bttn_options').events.unlisten(listenBttnOptions);
        menu.findChild('bttn_restart').events.unlisten(listenBttnRestart);
        menu.findChild('bttn_menu'   ).events.unlisten(listenBttnMenu);
    }

    override public function ondestroy()
    {
        Actuate.stop(background.color);
        Actuate.stop(menu.pos);

        menu.destroy();
        background.destroy();
    }

    private function onBttnResume(_)
    {
        background.color.tween(0.25, { a : 0 });
        Luxe.events.fire('puzzle.pause', { state : false });
        machine.unset();
    }

    private function onBttnOptions(_)
    {
        //
    }

    private function onBttnRestart(_)
    {
        machine.set('confirm', {
            onConfirm : function(_) { Luxe.events.fire('puzzle.restart'); },
            onCancel  : function(_) { machine.set('menu'); }
        });
    }

    private function onBttnMenu(_)
    {
        machine.set('confirm', {
            onConfirm : function(_) { Luxe.events.fire('puzzle.exit'); },
            onCancel  : function(_) { machine.set('menu'); }
        });
    }
}
