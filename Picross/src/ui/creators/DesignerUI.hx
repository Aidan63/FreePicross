package ui.creators;

import luxe.Vector;
import luxe.Visual;
import luxe.Color;
import luxe.Text;
import luxe.Sprite;
import luxe.NineSlice;
import luxe.Rectangle;
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
     *  Actual in designer UI / HUD
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
            name    : 'panel_pause',
            texture : Luxe.resources.texture('assets/images/ui/roundedPanel.png'),
            color   : new Color().rgb(0x333333),
            depth   : 8,
            top : 20, left : 20, bottom : 20, right : 20
        });
        panel.create(new Vector(0, 0), 640, 560);

        new Text({
            parent : panel,
            name   : 'label_title',
            text   : 'Designer',
            pos    : new Vector(320, 80),
            color  : new Color().rgb(0xe7e7e7),
            depth  : 9,
            align  : center,
            align_vertical : center,
            point_size : 64
        });

        var bttnResume = new NineSlice({
            parent  : panel,
            name    : 'bttn_resume',
            texture : Luxe.resources.texture('assets/images/ui/roundedButton.png'),
            depth   : 9,
            pos     : new Vector(20, 160),
            size    : new Vector(600, 80),
            top : 30, left : 30, bottom : 30, right : 30,
        });
        bttnResume.add(new components.ui.NineSliceButton({
            name : 'button',
            uvs : [
                new Rectangle(0  , 0, 80, 80),
                new Rectangle(80 , 0, 80, 80),
                new Rectangle(160, 0, 80, 80)
            ],
            colors : [ new Color(), new Color().rgb(0xe7e7e7), new Color().rgb(0xe7e7e7) ]
        }));
        bttnResume.add(new components.ui.Label({
            name : 'label',
            colors : [
                new Color().rgb(0x949494),
                new Color().rgb(0x949494),
                new Color().rgb(0x949494)
            ],
            offsets : [
                new Vector(300, 30),
                new Vector(300, 30),
                new Vector(300, 50),
            ],
            text : 'Resume',
            align : center,
            align_vertical : center,
            point_size : 24,
            depth : 10
        }));

        var bttnSave = new NineSlice({
            parent  : panel,
            name    : 'bttn_save',
            texture : Luxe.resources.texture('assets/images/ui/roundedButton.png'),
            depth   : 9,
            pos     : new Vector(20, 260),
            size    : new Vector(600, 80),
            top : 30, left : 30, bottom : 30, right : 30,
        });
        bttnSave.add(new components.ui.NineSliceButton({
            name : 'button',
            uvs : [
                new Rectangle(0  , 0, 80, 80),
                new Rectangle(80 , 0, 80, 80),
                new Rectangle(160, 0, 80, 80)
            ],
            colors : [ new Color(), new Color().rgb(0xe7e7e7), new Color().rgb(0xe7e7e7) ]
        }));
        bttnSave.add(new components.ui.Label({
            name : 'label',
            colors : [
                new Color().rgb(0x949494),
                new Color().rgb(0x949494),
                new Color().rgb(0x949494)
            ],
            offsets : [
                new Vector(300, 30),
                new Vector(300, 30),
                new Vector(300, 50),
            ],
            text : 'Save',
            align : center,
            align_vertical : center,
            point_size : 24,
            depth : 10
        }));

        var bttnExport = new NineSlice({
            parent  : panel,
            name    : 'bttn_export',
            texture : Luxe.resources.texture('assets/images/ui/roundedButton.png'),
            depth   : 9,
            pos     : new Vector(20, 360),
            size    : new Vector(600, 80),
            top : 30, left : 30, bottom : 30, right : 30,
        });
        bttnExport.add(new components.ui.NineSliceButton({
            name : 'button',
            uvs : [
                new Rectangle(0  , 0, 80, 80),
                new Rectangle(80 , 0, 80, 80),
                new Rectangle(160, 0, 80, 80)
            ],
            colors : [ new Color(), new Color().rgb(0xe7e7e7), new Color().rgb(0xe7e7e7) ]
        }));
        bttnExport.add(new components.ui.Label({
            name : 'label',
            colors : [
                new Color().rgb(0x949494),
                new Color().rgb(0x949494),
                new Color().rgb(0x949494)
            ],
            offsets : [
                new Vector(300, 30),
                new Vector(300, 30),
                new Vector(300, 50),
            ],
            text : 'Export',
            align : center,
            align_vertical : center,
            point_size : 24,
            depth : 10
        }));

        var bttnMenu = new NineSlice({
            parent  : panel,
            name    : 'bttn_menu',
            texture : Luxe.resources.texture('assets/images/ui/roundedButton.png'),
            depth   : 9,
            pos     : new Vector(20, 460),
            size    : new Vector(600, 80),
            top : 30, left : 30, bottom : 30, right : 30,
        });
        bttnMenu.add(new components.ui.NineSliceButton({
            name : 'button',
            uvs : [
                new Rectangle(0  , 0, 80, 80),
                new Rectangle(80 , 0, 80, 80),
                new Rectangle(160, 0, 80, 80)
            ],
            colors : [ new Color(), new Color().rgb(0xe7e7e7), new Color().rgb(0xe7e7e7) ]
        }));
        bttnMenu.add(new components.ui.Label({
            name : 'label',
            colors : [
                new Color().rgb(0x949494),
                new Color().rgb(0x949494),
                new Color().rgb(0x949494)
            ],
            offsets : [
                new Vector(300, 30),
                new Vector(300, 30),
                new Vector(300, 50),
            ],
            text : 'Exit to Menu',
            align : center,
            align_vertical : center,
            point_size : 24,
            depth : 10
        }));

        return panel;
    }

    /**
     *  Creates a visual which will hold all of the export options menu elements.
     *  @return Visual
     */
    public static inline function export() : Visual
    {
        var panel = new NineSlice({
            name    : 'panel_export',
            texture : Luxe.resources.texture('assets/images/ui/roundedPanel.png'),
            color   : new Color().rgb(0x333333),
            depth   : 8,
            top : 20, left : 20, bottom : 20, right : 20
        });
        panel.create(new Vector(0, 0), 640, 560);

        new Text({
            parent : panel,
            name   : 'label_title',
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
            name   : 'label_name',
            text   : 'Puzzle Name',
            pos    : new Vector(40, 180),
            color  : new Color(0.9, 0.9, 0.9, 1),
            depth  : 9,
            align  : left,
            align_vertical : center,
            point_size : 24
        });
        var panelEditName = new NineSlice({
            parent  : panel,
            name    : 'panel_textedit_name',
            texture : Luxe.resources.texture('assets/images/ui/roundedButton.png'),
            size    : new Vector(600, 40),
            depth   : 9,
            color   : new Color().rgb(0x494949),
            top : 20, left : 20, bottom : 20, right : 20,
            source_x : 160, source_y : 20, source_w : 80, source_h : 60
        });
        panelEditName.create(new Vector(40, 200), 560, 40);
        panelEditName.transform.world.auto_decompose = true;
        new Text({
            parent : panel,
            name   : 'textedit_name',
            text   : 'name',
            pos    : new Vector(60, 218),
            color  : new Color().rgb(0xa2a2a2),
            depth  : 9,
            align  : left,
            align_vertical : center,
            point_size : 24
        });

        new Text({
            parent : panel,
            name   : 'label_description',
            text   : 'Puzzle Description',
            pos    : new Vector(40, 260),
            color  : new Color(0.9, 0.9, 0.9, 1),
            depth  : 9,
            align  : left,
            align_vertical : center,
            point_size : 24
        });
        var panelEditDescription = new NineSlice({
            parent  : panel,
            name    : 'panel_textedit_description',
            texture : Luxe.resources.texture('assets/images/ui/roundedButton.png'),
            size    : new Vector(600, 40),
            depth   : 9,
            color   : new Color().rgb(0x494949),
            top : 20, left : 20, bottom : 20, right : 20,
            source_x : 160, source_y : 20, source_w : 80, source_h : 60
        });
        panelEditDescription.create(new Vector(40, 280), 560, 40);
        panelEditDescription.transform.world.auto_decompose = true;
        new Text({
            parent : panel,
            name   : 'textedit_description',
            text   : 'description',
            pos    : new Vector(60, 298),
            color  : new Color().rgb(0xa2a2a2),
            depth  : 9,
            align  : left,
            align_vertical : center,
            point_size : 24
        });

        var bttnExport = new NineSlice({
            parent  : panel,
            name    : 'bttn_export',
            texture : Luxe.resources.texture('assets/images/ui/roundedButton.png'),
            depth   : 9,
            pos     : new Vector(20, 360),
            size    : new Vector(600, 80),
            top : 30, left : 30, bottom : 30, right : 30,
        });
        bttnExport.add(new components.ui.NineSliceButton({
            name : 'button',
            uvs : [
                new Rectangle(0  , 0, 80, 80),
                new Rectangle(80 , 0, 80, 80),
                new Rectangle(160, 0, 80, 80)
            ],
            colors : [ new Color(), new Color().rgb(0xe7e7e7), new Color().rgb(0xe7e7e7) ]
        }));
        bttnExport.add(new components.ui.Label({
            name : 'label',
            colors : [
                new Color().rgb(0x949494),
                new Color().rgb(0x949494),
                new Color().rgb(0x949494)
            ],
            offsets : [
                new Vector(300, 30),
                new Vector(300, 30),
                new Vector(300, 50)
            ],
            text : 'Export',
            align : center,
            align_vertical : center,
            point_size : 24,
            depth : 10
        }));

        var bttnCancel = new NineSlice({
            parent  : panel,
            name    : 'bttn_cancel',
            texture : Luxe.resources.texture('assets/images/ui/roundedButton.png'),
            depth   : 9,
            pos     : new Vector(20, 460),
            size    : new Vector(600, 80),
            top : 30, left : 30, bottom : 30, right : 30,
        });
        bttnCancel.add(new components.ui.NineSliceButton({
            name : 'button',
            uvs : [
                new Rectangle(0  , 0, 80, 80),
                new Rectangle(80 , 0, 80, 80),
                new Rectangle(160, 0, 80, 80)
            ],
            colors : [ new Color(), new Color().rgb(0xe7e7e7), new Color().rgb(0xe7e7e7) ]
        }));
        bttnCancel.add(new components.ui.Label({
            name : 'label',
            colors : [
                new Color().rgb(0x949494),
                new Color().rgb(0x949494),
                new Color().rgb(0x949494)
            ],
            offsets : [
                new Vector(300, 30),
                new Vector(300, 30),
                new Vector(300, 50)
            ],
            text : 'Cancel',
            align : center,
            align_vertical : center,
            point_size : 24,
            depth : 10
        }));

        return panel;
    }
}
