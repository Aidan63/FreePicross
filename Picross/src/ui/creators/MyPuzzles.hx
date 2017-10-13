package ui.creators;

import luxe.Vector;
import luxe.Text;
import luxe.Visual;
import luxe.NineSlice;
import luxe.Color;
import luxe.Rectangle;

class MyPuzzles
{
    public static inline function previewPanel() : Visual
    {
        var frame = Picross.atlas.getFrame('ui', 'roundedPanel');
        var panel = new NineSlice({
            name : 'preview_panel',
            name_unique : true,
            texture : Luxe.resources.texture('assets/images/ui.png'),
            top : 20, left : 20, bottom : 20, right : 20,
            source_x : frame.uv.x, source_y : frame.uv.y, source_w : frame.uv.w, source_h : frame.uv.h,
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
        var bttnCreate = new NineSlice({
            parent  : panel,
            name    : 'bttn_play',
            depth   : 1,
            texture : Luxe.resources.texture('assets/images/ui.png'),
            pos     : new Vector(20, 480),
            size    : new Vector(540, 60),
            top : 30, left : 30, bottom : 30, right : 30,
        });
        bttnCreate.add(new components.ui.NineSliceButton({
            name : 'button',
            uvs : [
                Picross.atlas.getFrame('ui', 'roundedButton0').uv,
                Picross.atlas.getFrame('ui', 'roundedButton1').uv,
                Picross.atlas.getFrame('ui', 'roundedButton2').uv
            ],
            colors : [
                new Color(0.86, 0.86, 0.86, 1),
                new Color(0.72, 0.72, 0.72, 1),
                new Color(0.72, 0.72, 0.72, 1)
            ]
        }));
        bttnCreate.add(new components.ui.Label({
            name : 'label',
            colors : [
                new Color(0.58, 0.58, 0.58, 1),
                new Color(0.58, 0.58, 0.58, 1),
                new Color(0.58, 0.58, 0.58, 1)
            ],
            offsets : [
                new Vector(270, 20),
                new Vector(270, 20),
                new Vector(270, 40),
            ],
            text : 'Play',
            align : center,
            align_vertical : center,
            point_size : 24,
            depth : 2
        }));
        var bttnCreate = new NineSlice({
            parent  : panel,
            name    : 'bttn_delete',
            depth   : 1,
            texture : Luxe.resources.texture('assets/images/ui.png'),
            pos     : new Vector(20, 560),
            size    : new Vector(540, 60),
            top : 30, left : 30, bottom : 30, right : 30,
        });
        bttnCreate.add(new components.ui.NineSliceButton({
            name : 'button',
            uvs : [
                Picross.atlas.getFrame('ui', 'roundedButton0').uv,
                Picross.atlas.getFrame('ui', 'roundedButton1').uv,
                Picross.atlas.getFrame('ui', 'roundedButton2').uv
            ],
            colors : [
                new Color(0.86, 0.86, 0.86, 1),
                new Color(0.72, 0.72, 0.72, 1),
                new Color(0.72, 0.72, 0.72, 1)
            ]
        }));
        bttnCreate.add(new components.ui.Label({
            name : 'label',
            colors : [
                new Color(0.58, 0.58, 0.58, 1),
                new Color(0.58, 0.58, 0.58, 1),
                new Color(0.58, 0.58, 0.58, 1)
            ],
            offsets : [
                new Vector(270, 20),
                new Vector(270, 20),
                new Vector(270, 40),
            ],
            text : 'Delete',
            align : center,
            align_vertical : center,
            point_size : 24,
            depth : 2
        }));

        return panel;
    }

    public static inline function newPuzzlePopup() : Visual
    {
        var frame = Picross.atlas.getFrame('ui', 'roundedPanel');
        var panel = new NineSlice({
            name    : 'panel_main',
            texture : Luxe.resources.texture('assets/images/ui.png'),
            color   : new Color().rgb(0x333333),
            depth   : 8,
            top : 20, left : 20, bottom : 20, right : 20,
            source_x : frame.uv.x, source_y : frame.uv.y, source_w : frame.uv.w, source_h : frame.uv.h,
        });
        panel.create(new Vector(0, 0), 680, 500);

        new Text({
            parent : panel,
            name   : 'label_title',
            pos    : new Vector(340, 60),
            text   : 'New Puzzle',
            depth  : 9,
            align  : center,
            align_vertical : center,
            point_size : 48
        });

        new Text({
            parent : panel,
            name : 'label_rows',
            pos : new Vector(40, 145),
            depth  : 9,
            point_size : 32,
            text : 'rows',
            align : left,
            align_vertical : center
        });
        new Text({
            parent : panel,
            name : 'label_columns',
            pos : new Vector(40, 225),
            depth  : 9,
            point_size : 32,
            text : 'columns',
            align : left,
            align_vertical : center
        });

        var widthPanel = new NineSlice({
            parent : panel,
            name : 'panel_rows',
            size : new Vector(440, 60),
            texture : Luxe.resources.texture('assets/images/ui.png'),
            color   : new Color().rgb(0x494949),
            depth   : 8,
            top : 20, left : 20, bottom : 20, right : 20,
            source_x : frame.uv.x, source_y : frame.uv.y, source_w : frame.uv.w, source_h : frame.uv.h
        });
        widthPanel.create(new Vector(200, 120), 440, 60);
        widthPanel.transform.world.auto_decompose = true; 

        var heightPanel = new NineSlice({
            parent : panel,
            name : 'panel_columns',
            size : new Vector(440, 60),
            texture : Luxe.resources.texture('assets/images/ui.png'),
            color   : new Color().rgb(0x494949),
            depth   : 8,
            top : 20, left : 20, bottom : 20, right : 20,
            source_x : frame.uv.x, source_y : frame.uv.y, source_w : frame.uv.w, source_h : frame.uv.h,
        });
        heightPanel.create(new Vector(200, 200), 440, 60);
        heightPanel.transform.world.auto_decompose = true; 

        new Text({
            parent : panel,
            name : 'textentry_rows',
            pos : new Vector(240, 145),
            depth  : 9,
            point_size : 32,
            text : '8',
            align : left,
            align_vertical : center
        });
        new Text({
            parent : panel,
            name : 'textentry_columns',
            pos : new Vector(240, 225),
            depth  : 9,
            point_size : 32,
            text : '8',
            align : left,
            align_vertical : center
        });

        var bttnCreate = new NineSlice({
            parent  : panel,
            name    : 'bttn_create',
            texture : Luxe.resources.texture('assets/images/ui.png'),
            depth   : 9,
            pos     : new Vector(20, 300),
            size    : new Vector(640, 80),
            top : 30, left : 30, bottom : 30, right : 30,
        });
        bttnCreate.add(new components.ui.NineSliceButton({
            name : 'button',
            uvs : [
                Picross.atlas.getFrame('ui', 'roundedButton0').uv,
                Picross.atlas.getFrame('ui', 'roundedButton1').uv,
                Picross.atlas.getFrame('ui', 'roundedButton2').uv
            ],
            colors : [
                new Color(0.86, 0.86, 0.86, 1),
                new Color(0.72, 0.72, 0.72, 1),
                new Color(0.72, 0.72, 0.72, 1)
            ]
        }));
        bttnCreate.add(new components.ui.Label({
            name : 'label',
            colors : [
                new Color(0.58, 0.58, 0.58, 1),
                new Color(0.58, 0.58, 0.58, 1),
                new Color(0.58, 0.58, 0.58, 1)
            ],
            offsets : [
                new Vector(320, 30),
                new Vector(320, 30),
                new Vector(320, 50),
            ],
            text : 'Create',
            align : center,
            align_vertical : center,
            point_size : 24,
            depth : 10
        }));
        var bttnCreate = new NineSlice({
            parent  : panel,
            name    : 'bttn_cancel',
            texture : Luxe.resources.texture('assets/images/ui.png'),
            depth   : 9,
            pos     : new Vector(20, 400),
            size    : new Vector(640, 80),
            top : 30, left : 30, bottom : 30, right : 30,
        });
        bttnCreate.add(new components.ui.NineSliceButton({
            name : 'button',
            uvs : [
                Picross.atlas.getFrame('ui', 'roundedButton0').uv,
                Picross.atlas.getFrame('ui', 'roundedButton1').uv,
                Picross.atlas.getFrame('ui', 'roundedButton2').uv
            ],
            colors : [
                new Color(0.86, 0.86, 0.86, 1),
                new Color(0.72, 0.72, 0.72, 1),
                new Color(0.72, 0.72, 0.72, 1)
            ]
        }));
        bttnCreate.add(new components.ui.Label({
            name : 'label',
            colors : [
                new Color(0.58, 0.58, 0.58, 1),
                new Color(0.58, 0.58, 0.58, 1),
                new Color(0.58, 0.58, 0.58, 1)
            ],
            offsets : [
                new Vector(320, 30),
                new Vector(320, 30),
                new Vector(320, 50),
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
