package ui.creators;

import luxe.Vector;
import luxe.Visual;
import luxe.Color;
import luxe.Text;
import luxe.Sprite;
import luxe.NineSlice;
import luxe.components.sprite.SpriteAnimation;
import components.ui.Button;
import game.PuzzleState;

class DesignerUI
{
    public static var paints = [
        new Color().rgb(0x000000),
        new Color().rgb(0x1d2b53),
        new Color().rgb(0x7e2553),
        new Color().rgb(0x008751),
        new Color().rgb(0xab5236),
        new Color().rgb(0x5f574f),
        new Color().rgb(0xc2c3c7),
        new Color().rgb(0xfff1e8),
        new Color().rgb(0xff004d),
        new Color().rgb(0xffa300),
        new Color().rgb(0xffec27),
        new Color().rgb(0x00e436),
        new Color().rgb(0x29adff),
        new Color().rgb(0x83769c),
        new Color().rgb(0xff77a8),
        new Color().rgb(0xffccaa)
    ];

    /**
     *  [Description]
     *  @return Visual
     */
    public static function create() : Visual
    {
        var panel = new Visual({
            name  : 'ui_panel',
            pos   : new Vector(0, 592),
            size  : new Vector(1280, 128),
            color : new Color(0.2, 0.2, 0.2, 1)
        });

        var export = new Visual({
            parent  : panel,
            name    : 'ui_export',
            pos     : new Vector(0, 0),
            size    : new Vector(128, 128),
            texture : Luxe.resources.texture('assets/images/ui/buttonExport.png')
        });
        export.add(new components.ui.Button({ name : 'button' }));

        var paintPrimary = new Visual({
            parent   : panel,
            name     : 'ui_paintPrimary',
            pos      : new Vector(128, 0),
            size     : new Vector(128, 128),
            color    : PuzzleState.color.colors.get(Primary)
        });
        paintPrimary.add(new components.ui.Button({ name : 'button' }));

        var paintSecondary = new Visual({
            parent   : panel,
            name     : 'ui_paintSecondary',
            pos      : new Vector(256, 0),
            size     : new Vector(128, 128),
            color    : PuzzleState.color.colors.get(Secondary)
        });
        paintSecondary.add(new components.ui.Button({ name : 'button' }));

        var puzzlePaintSelector = new Sprite({
            parent  : panel,
            name    : 'ui_puzzlePaintSelector',
            texture : Luxe.resources.texture('assets/images/ui/paintSelector.png'),
            pos     : paintPrimary.pos,
            size    : new Vector(128, 128),
            origin  : new Vector(0, 0)
        });
        var anim : SpriteAnimation = puzzlePaintSelector.add(new SpriteAnimation({ name : 'animation' }));
        anim.add_from_json_object(Luxe.resources.json('assets/data/animations/paintSelector.json').asset.json);
        anim.animation = 'idle';
        anim.play();

        createDesignerPaints(panel);

        return panel;
    }

    private static function createDesignerPaints(_parent : Visual)
    {
        var paintHolder = new Visual({
            parent : _parent,
            name   : 'ui_paintsHolder',
            pos    : new Vector(768, 0),
            size   : new Vector(512, 128),
            color  : new Color(0.16, 0.16, 0.16, 1)
        });

        for (i in 0...paints.length)
        {
            var x = i % (paints.length / 2);
            var y = i / (paints.length / 2) >= 1 ? 1 : 0;

            var paint = new Visual({
                parent : paintHolder,
                name   : 'ui_paint$i',
                pos    : new Vector(x * 64, y * 64),
                size   : new Vector(64, 64),
                color  : paints[i]
            });
            paint.add(new components.ui.Button({ name : 'button' }));
        }

        var puzzlePaintSelector = new Sprite({
            parent  : paintHolder,
            name    : 'ui_designerPaintSelector',
            texture : Luxe.resources.texture('assets/images/ui/paintSelector.png'),
            pos     : new Vector(0, 0),
            size    : new Vector(64, 64),
            origin  : new Vector(0, 0)
        });
        var anim : SpriteAnimation = puzzlePaintSelector.add(new SpriteAnimation({ name : 'animation' }));
        anim.add_from_json_object(Luxe.resources.json('assets/data/animations/paintSelector.json').asset.json);
        anim.animation = 'idle';
        anim.play();
    }

    /**
     *  Create the main menu for the designer.
     *  @return Visual
     */
    public static inline function menu() : Visual
    {
        var panel = new NineSlice({
            name    : 'ui_designer_menu_panel',
            texture : Luxe.resources.texture('assets/images/ui/roundedPanel.png'),
            color   : new Color(0.32, 0.32, 0.32, 1),
            depth   : 8,
            top : 20, left : 20, bottom : 20, right : 20
        });
        panel.create(new Vector(0, 0), 640, 560);

        var labelPos = [ new Vector(300, 30), new Vector(300, 30), new Vector(300, 50) ];
        var labelCol = [ new Color(0.54, 0.54, 0.54, 1), new Color(0.54, 0.54, 0.54, 1), new Color(0.54, 0.54, 0.54, 1) ];
        var texCol = [ new Color(0.86, 0.86, 0.86, 1), new Color(0.72, 0.72, 0.72, 1), new Color(0.72, 0.72, 0.72, 1) ];
        var texUVs = [ new luxe.Rectangle(0  , 0, 80, 80), new luxe.Rectangle(80 , 0, 80, 80), new luxe.Rectangle(160, 0, 80, 80) ];

        new Text({
            parent : panel,
            name   : 'ui_designer_menu_title',
            text   : 'Designer',
            pos    : new Vector(320, 80),
            color  : new Color(0.9, 0.9, 0.9, 1),
            depth  : 9,
            align  : center,
            align_vertical : center,
            point_size : 64
        });

        new ui.Button({
            parent  : panel,
            name    : 'ui_designer_menu_bttnResume',
            texture : Luxe.resources.texture('assets/images/ui/roundedButton.png'),
            depth   : 9,
            pos     : new Vector(20, 160),
            size    : new Vector(600, 80),
            top : 30, left : 30, bottom : 30, right : 30,
            labelOffsets  : labelPos,
            labelColors   : labelCol,
            textureUVs    : texUVs,
            textureColors : texCol,
            label : new luxe.Text({
                name : 'ui_designer_menu_bttnResumeText',
                text : 'Resume',
                point_size : 32,
                depth : 10,
                align : center,
                align_vertical : center
            })
        });

        new ui.Button({
            parent  : panel,
            name    : 'ui_designer_menu_bttnSave',
            texture : Luxe.resources.texture('assets/images/ui/roundedButton.png'),
            depth   : 9,
            pos     : new Vector(20, 260),
            size    : new Vector(600, 80),
            top : 30, left : 30, bottom : 30, right : 30,
            labelOffsets  : labelPos,
            labelColors   : labelCol,
            textureUVs    : texUVs,
            textureColors : texCol,
            label : new luxe.Text({
                name : 'ui_designer_menu_bttnSaveText',
                text : 'Save',
                point_size : 32,
                depth : 10,
                align : center,
                align_vertical : center
            })
        });

        new ui.Button({
            parent  : panel,
            name    : 'ui_designer_menu_bttnExport',
            texture : Luxe.resources.texture('assets/images/ui/roundedButton.png'),
            depth   : 9,
            pos     : new Vector(20, 360),
            size    : new Vector(600, 80),
            top : 30, left : 30, bottom : 30, right : 30,
            labelOffsets  : labelPos,
            labelColors   : labelCol,
            textureUVs    : texUVs,
            textureColors : texCol,
            label : new luxe.Text({
                name : 'ui_designer_menu_bttnExportText',
                text : 'Export',
                point_size : 32,
                depth : 10,
                align : center,
                align_vertical : center
            })
        });

        new ui.Button({
            parent  : panel,
            name    : 'ui_designer_menu_bttnMenu',
            texture : Luxe.resources.texture('assets/images/ui/roundedButton.png'),
            depth   : 9,
            pos     : new Vector(20, 460),
            size    : new Vector(600, 80),
            top : 30, left : 30, bottom : 30, right : 30,
            labelOffsets  : labelPos,
            labelColors   : labelCol,
            textureUVs    : texUVs,
            textureColors : texCol,
            label : new luxe.Text({
                name : 'ui_designer_menu_bttnMenuText',
                text : 'Exit to Menu',
                point_size : 32,
                depth : 10,
                align : center,
                align_vertical : center
            })
        });

        return panel;
    }

    /**
     *  Creates a visual which will hold all of the export options menu elements.
     *  @return Visual
     */
    public static inline function export() : Visual
    {
        var panel = new NineSlice({
            name    : 'ui_designer_export_panel',
            texture : Luxe.resources.texture('assets/images/ui/roundedPanel.png'),
            color   : new Color(0.32, 0.32, 0.32, 1),
            depth   : 8,
            top : 20, left : 20, bottom : 20, right : 20
        });
        panel.create(new Vector(0, 0), 640, 560);

        var labelPos = [ new Vector(300, 30), new Vector(300, 30), new Vector(300, 50) ];
        var labelCol = [ new Color(0.54, 0.54, 0.54, 1), new Color(0.54, 0.54, 0.54, 1), new Color(0.54, 0.54, 0.54, 1) ];
        var texCol = [ new Color(0.86, 0.86, 0.86, 1), new Color(0.72, 0.72, 0.72, 1), new Color(0.72, 0.72, 0.72, 1) ];
        var texUVs = [ new luxe.Rectangle(0  , 0, 80, 80), new luxe.Rectangle(80 , 0, 80, 80), new luxe.Rectangle(160, 0, 80, 80) ];

        new Text({
            parent : panel,
            name   : 'ui_designer_export_title',
            text   : 'Export Options',
            pos    : new Vector(320, 80),
            color  : new Color(0.9, 0.9, 0.9, 1),
            depth  : 9,
            align  : center,
            align_vertical : center,
            point_size : 64
        });

        new Text({
            parent : panel,
            name   : 'ui_designer_export_inputNameTitle',
            text   : 'Puzzle Name',
            pos    : new Vector(40, 180),
            color  : new Color(0.9, 0.9, 0.9, 1),
            depth  : 9,
            align  : left,
            align_vertical : center,
            point_size : 24
        });
        new ui.TextInput({
            colors : [ new Color().rgb(0x5e5e5e), new Color().rgb(0x7e7e7e) ],
            background : {
                parent : panel,
                name : 'ui_designer_export_inputName',
                texture : Luxe.resources.texture('assets/images/ui/roundedButton.png'),
                pos : new Vector(20, 200),
                size : new Vector(600, 40),
                depth : 9,
                top : 20, left : 20, bottom : 20, right : 20,
                source_x : 160, source_y : 20, source_w : 80, source_h : 60
            },
            text : {
                name : 'ui_designer_export_inputNameText',
                text : 'test',
                pos : new Vector(20, 20),
                color : new Color(0.9, 0.9, 0.9, 1),
                depth : 10,
                align : left,
                align_vertical : center,
                point_size : 20
            }
        });

        new Text({
            parent : panel,
            name   : 'ui_designer_export_inputDescriptionTitle',
            text   : 'Puzzle Description',
            pos    : new Vector(40, 260),
            color  : new Color(0.9, 0.9, 0.9, 1),
            depth  : 9,
            align  : left,
            align_vertical : center,
            point_size : 24
        });
        new ui.TextInput({
            colors : [ new Color().rgb(0x5e5e5e), new Color().rgb(0x7e7e7e) ],
            background : {
                parent : panel,
                name : 'ui_designer_export_inputDescription',
                texture : Luxe.resources.texture('assets/images/ui/roundedButton.png'),
                pos : new Vector(20, 280),
                size : new Vector(600, 40),
                depth : 9,
                top : 20, left : 20, bottom : 20, right : 20,
                source_x : 160, source_y : 20, source_w : 80, source_h : 60
            },
            text : {
                name : 'ui_designer_export_inputDescriptionText',
                text : 'test',
                pos : new Vector(20, 20),
                color : new Color(0.9, 0.9, 0.9, 1),
                depth : 10,
                align : left,
                align_vertical : center,
                point_size : 20
            }
        });

        new ui.Button({
            parent  : panel,
            name    : 'ui_designer_export_bttnExport',
            texture : Luxe.resources.texture('assets/images/ui/roundedButton.png'),
            depth   : 9,
            pos     : new Vector(20, 360),
            size    : new Vector(600, 80),
            top : 30, left : 30, bottom : 30, right : 30,
            labelOffsets  : labelPos,
            labelColors   : labelCol,
            textureUVs    : texUVs,
            textureColors : texCol,
            label : new luxe.Text({
                name : 'ui_designer_export_bttnExportText',
                text : 'Export',
                point_size : 32,
                depth : 10,
                align : center,
                align_vertical : center
            })
        });
        new ui.Button({
            parent  : panel,
            name    : 'ui_designer_export_bttnCancel',
            texture : Luxe.resources.texture('assets/images/ui/roundedButton.png'),
            depth   : 9,
            pos     : new Vector(20, 460),
            size    : new Vector(600, 80),
            top : 30, left : 30, bottom : 30, right : 30,
            labelOffsets  : labelPos,
            labelColors   : labelCol,
            textureUVs    : texUVs,
            textureColors : texCol,
            label : new luxe.Text({
                name : 'ui_designer_export_bttnCancelText',
                text : 'Cancel',
                point_size : 32,
                depth : 10,
                align : center,
                align_vertical : center
            })
        });

        return panel;
    }
}
