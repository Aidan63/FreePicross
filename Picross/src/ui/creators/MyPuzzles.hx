package ui.creators;

import luxe.Vector;
import luxe.Visual;
import luxe.NineSlice;
import luxe.Color;

class MyPuzzles
{
    public static inline function previewPanel() : Visual
    {
        var panel = new NineSlice({
            name : 'preview_panel',
            name_unique : true,
            texture : Luxe.resources.texture('assets/images/ui/roundedPanel.png'),
            top : 20, left : 20, bottom : 20, right : 20,
            color : new Color().rgb(0x333333),
        });
        panel.create(new Vector(660, 40), 580, 640);

        return panel;
    }
}
