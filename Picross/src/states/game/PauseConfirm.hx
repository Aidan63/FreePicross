package states.game;

import luxe.States;
import luxe.Visual;
import luxe.tween.Actuate;
using utils.EntityHelper;

class PauseConfirm extends State
{
    /**
     *  The parent visual entity which will hold the menu items.
     */
    private var menu : Visual;

    /**
     *  The function to call when the confirm button is clicked.
     */
    private var onConfirm : Dynamic -> Void;

    /**
     *  The function to call when the cancel button is clicked.
     */
    private var onCancel : Dynamic -> Void;

    private var listenConfirm : String;
    private var listenCancel : String;

    override public function init()
    {
        menu = ui.creators.Game.createPauseConfirm();
        menu.pos.set_xy(320, 720);
    }

    override public function onenter<T>(_data : T)
    {
        var functions : ConfirmFunctions = cast _data;
        onConfirm = functions.onConfirm;
        onCancel = functions.onCancel;

        Actuate.tween(menu.pos, 0.25, { y : 240 });

        listenConfirm = menu.findChild('bttn_confirm').events.listen('released', onConfirm);
        listenCancel  = menu.findChild('bttn_cancel').events.listen('released', onCancel);
    }

    override public function onleave<T>(_data : T)
    {
        Actuate.tween(menu.pos, 0.25, { y : 720 });

        menu.findChild('bttn_confirm').events.unlisten(listenConfirm);
        menu.findChild('bttn_cancel').events.unlisten(listenCancel);
    }

    override public function ondestroy()
    {
        menu.destroy();
    }
}

typedef ConfirmFunctions = {
    var onConfirm : Dynamic -> Void;
    var onCancel  : Dynamic -> Void;
}
