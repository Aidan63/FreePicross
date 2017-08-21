package ui.creators;

import luxe.Vector;
import luxe.Text;
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

        new Text({
            parent : panel,
            name : 'title',
            point_size : 64,
            text : '',
            pos : new Vector(20, 60),
            align : left,
            align_vertical : center
        });

        new Visual({
            parent : panel,
            name : 'preview',
            pos : new Vector(40, 160),
            size : new Vector(200, 200)
        });

        new Text({
            parent : panel,
            name : 'description',
            point_size : 32,
            text : '',
            pos : new Vector(40, 420),
            align : left,
            align_vertical : center
        });

        // Add play and remove buttons.
        var labelPos = [ new Vector(270, 20), new Vector(270, 20), new Vector(270, 40) ];
        var labelCol = [ new Color(0.54, 0.54, 0.54, 1), new Color(0.54, 0.54, 0.54, 1), new Color(0.54, 0.54, 0.54, 1) ];
        var texCol = [ new Color(0.86, 0.86, 0.86, 1), new Color(0.72, 0.72, 0.72, 1), new Color(0.72, 0.72, 0.72, 1) ];
        var texUVs = [ new luxe.Rectangle(0  , 0, 80, 80), new luxe.Rectangle(80 , 0, 80, 80), new luxe.Rectangle(160, 0, 80, 80) ];

        new Button({
            parent  : panel,
            name    : 'bttnPlay',
            texture : Luxe.resources.texture('assets/images/ui/roundedButton.png'),
            depth   : 3,
            pos     : new Vector(20, 480),
            size    : new Vector(540, 60),
            top : 30, left : 30, bottom : 30, right : 30,
            labelOffsets  : labelPos,
            labelColors   : labelCol,
            textureUVs    : texUVs,
            textureColors : texCol,
            label : new luxe.Text({
                name : 'bttnPlayText',
                text : 'Play',
                point_size : 24,
                depth : 4,
                align : center,
                align_vertical : center
            })
        });
        new Button({
            parent  : panel,
            name    : 'bttnDelete',
            texture : Luxe.resources.texture('assets/images/ui/roundedButton.png'),
            depth   : 3,
            pos     : new Vector(20, 560),
            size    : new Vector(540, 60),
            top : 30, left : 30, bottom : 30, right : 30,
            labelOffsets  : labelPos,
            labelColors   : labelCol,
            textureUVs    : texUVs,
            textureColors : texCol,
            label : new luxe.Text({
                name : 'bttnDeleteText',
                text : 'Delete',
                point_size : 24,
                depth : 4,
                align : center,
                align_vertical : center
            })
        });

        return panel;
    }

    public static inline function newPuzzlePopup() : Visual
    {
        return new Visual({});
    }
}
