package states;

import luxe.States;
import luxe.Visual;
import ui.designer.DesignerUI;

using utils.EntityHelper;

class DesignerPause extends State
{
    private var popup : Visual;

    override public function onenabled<T>(_data : T)
    {
        Luxe.events.fire('designer.pause', { state : true });

        popup = DesignerUI.exportPopup();
        var panel = popup.findChild('ui_export_panel');

        panel.findChild('ui_export_bttnExport').events.listen('clicked', onExportClicked);
        panel.findChild('ui_export_bttnMenu'  ).events.listen('clicked', onMenuClicked);
        panel.findChild('ui_export_bttnReturn').events.listen('clicked', onReturnClicked);
    }

    override public function ondisabled<T>(_data : T)
    {
        popup.destroy();

        Luxe.events.fire('designer.pause', { state : false });
    }

    /**
     *  Export popup events.
     */

    /**
     *  Called when the return button is clicked on the export popup menu.
     *  Destroys the popup and re-enables the UI and two displays.
     */
    private function onReturnClicked(_)
    {
        machine.disable('designer_pause');
    }

    private function onMenuClicked(_)
    {
        machine.disable('designer_pause');
        machine.set('designer_list');
    }

    private function onExportClicked(_)
    {
        var panel = popup.findChild('ui_export_panel');
        var puzzleName : String = cast(panel.findChild('ui_export_textName'), luxe.Text).text;

        Luxe.events.fire('designer.export', { name : puzzleName });

        machine.disable('designer_pause');
    }
}
