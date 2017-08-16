package ui.designer;

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

    public static function exportPopup() : Visual
    {
        // Semi transparent backdrop
        var backdrop = new Visual({
            name  : 'ui_export_backdrop',
            pos   : new Vector(0, 0),
            size  : new Vector(1280, 720),
            color : new Color(0, 0, 0, 0.5),
            depth : 5
        });

        // Solid colour panel
        var panel = new Visual({
            parent  : backdrop,
            name    : 'ui_export_panel',
            pos     : new Vector(304, 32),
            size    : new Vector(672, 656),
            color   : new Color().rgb(0x333333),
            depth   : 6,
        });

        //Outline to contain the export options.
        new Visual({
            name     : 'ui_export_outline',
            parent   : panel,
            depth    : 7,
            color    : new Color().rgb(0x636363),
            geometry : Luxe.draw.rectangle({
                x : 16, y : 16, w : 640, h : 272
            })
        });

        new Text({
            parent : panel,
            name : 'ui_export_title',
            pos : new Vector(336, 48),
            align : center,
            text : 'Export Options',
            align_vertical : center,
            point_size : 16,
            depth : 7
        });
        new Text({
            parent : panel,
            name : 'ui_export_nameTitle',
            pos : new Vector(32, 96),
            align : left,
            align_vertical : center,
            point_size : 16,
            text : 'Type to enter puzzle name',
            depth : 7
        });

        var textName = new Text({
            parent : panel,
            name : 'ui_export_textName',
            pos : new Vector(336, 160),
            align : center,
            align_vertical : center,
            point_size : 32,
            depth : 7
        });
        textName.add(new components.ui.Input({ name : 'input' }));

        var bttnExport = new Visual({
            parent  : panel,
            name    : 'ui_export_bttnExport',
            pos     : new Vector(32, 208),
            size    : new Vector(608, 64),
            color   : new Color().rgb(0x636363),
            depth   : 7,
        });
        bttnExport.add(new components.ui.Button({ name : 'button' }));

        var bttnMenu = new Visual({
            parent  : panel,
            name    : 'ui_export_bttnMenu',
            pos     : new Vector(32, 480),
            size    : new Vector(608, 64),
            color   : new Color().rgb(0x636363),
            depth   : 7,
        });
        bttnMenu.add(new components.ui.Button({ name : 'button' }));

        var bttnReturn = new Visual({
            parent  : panel,
            name    : 'ui_export_bttnReturn',
            pos     : new Vector(32, 560),
            size    : new Vector(608, 64),
            color   : new Color().rgb(0x636363),
            depth   : 7,
        });
        bttnReturn.add(new components.ui.Button({ name : 'button' }));

        return backdrop;
    }

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

        var bttnResume = new NineSlice({
            parent  : panel,
            name    : 'ui_designer_menu_bttnResume',
            texture : Luxe.resources.texture('assets/images/ui/roundedButton.png'),
            color   : new Color(0.86, 0.86, 0.86, 1),
            depth   : 9,
            top      : 30, left     : 30, bottom   : 30, right    : 30,
            source_x : 0 , source_y : 0 , source_w : 80, source_h : 80
        });
        bttnResume.create(new Vector(20, 160), 600, 80);
        bttnResume.add(new components.ui.NineSliceSwitcher({ name : 'button' }));

        var bttnSave = new NineSlice({
            parent  : panel,
            name    : 'ui_designer_menu_bttnSave',
            texture : Luxe.resources.texture('assets/images/ui/roundedButton.png'),
            color   : new Color(0.86, 0.86, 0.86, 1),
            depth   : 9,
            top      : 30, left     : 30, bottom   : 30, right    : 30,
            source_x : 0 , source_y : 0 , source_w : 80, source_h : 80
        });
        bttnSave.create(new Vector(20, 260), 600, 80);
        bttnSave.add(new components.ui.NineSliceSwitcher({ name : 'button' }));

        var bttnExport = new NineSlice({
            parent  : panel,
            name    : 'ui_designer_menu_bttnExport',
            texture : Luxe.resources.texture('assets/images/ui/roundedButton.png'),
            color   : new Color(0.86, 0.86, 0.86, 1),
            depth   : 9,
            top      : 30, left     : 30, bottom   : 30, right    : 30,
            source_x : 0 , source_y : 0 , source_w : 80, source_h : 80
        });
        bttnExport.create(new Vector(20, 360), 600, 80);
        bttnExport.add(new components.ui.NineSliceSwitcher({ name : 'button' }));

        var bttnMenu = new NineSlice({
            parent  : panel,
            name    : 'ui_designer_menu_bttnMenu',
            texture : Luxe.resources.texture('assets/images/ui/roundedButton.png'),
            color   : new Color(0.86, 0.86, 0.86, 1),
            depth   : 9,
            top      : 30, left     : 30, bottom   : 30, right    : 30,
            source_x : 0 , source_y : 0 , source_w : 80, source_h : 80
        });
        bttnMenu.create(new Vector(20, 460), 600, 80);
        bttnMenu.add(new components.ui.NineSliceSwitcher({ name : 'button' }));

        return panel;
    }

    /*
    public function new(_puzzle : Visual)
    {
        puzzle = _puzzle;

        panel = new Visual({
            pos : new Vector(0, 0),
            size : new Vector(128, Luxe.camera.viewport.h),
            color : new Color().rgb(0x363636)
        });

        export = new Visual({
            name   : 'ui_export',
            parent : panel,
            pos    : new Vector(0, 0),
            size   : new Vector(128, 128),
            color  : new Color().rgb(0x2b2b2b)
        });
        export.add(new components.ui.Button({ name : 'button' }));

        paintPrimary = new Visual({
            name     : 'ui_paintPrimary',
            parent   : panel,
            pos      : new Vector(0, 128),
            size     : new Vector(128, 128),
            color    : PuzzleState.color.colors.get(Primary)
        });
        paintPrimary.add(new components.ui.Button({ name : 'button' }));

        paintSecondary = new Visual({
            name     : 'ui_paintSecondary',
            parent   : panel,
            pos      : new Vector(0, 256),
            size     : new Vector(128, 128),
            color    : PuzzleState.color.colors.get(Secondary)
        });
        paintSecondary.add(new components.ui.Button({ name : 'button' }));

        paintSelector = new Sprite({
            name    : 'ui_paintSelector',
            parent  : panel,
            texture : Luxe.resources.texture('assets/images/ui/paintSelector.png'),
            pos     : paintPrimary.pos,
            size    : new Vector(128, 128),
            origin  : new Vector(0, 0)
        });
        var anim : SpriteAnimation = paintSelector.add(new SpriteAnimation({ name : 'animation' }));
        anim.add_from_json_object(Luxe.resources.json('assets/data/animations/paintSelector.json').asset.json);
        anim.animation = 'idle';
        anim.play();

        export        .events.listen('clicked', onExportClicked);
        paintPrimary  .events.listen('clicked', onPrimaryPressed);
        paintSecondary.events.listen('clicked', onSecondaryPressed);
    }

    private function onPrimaryPressed(_)
    {
        PuzzleState.color.currentColor = Primary;

        // Slide the selector to this button.
        if (paintSelector.has('slide')) paintSelector.remove('slide');
        paintSelector.add(new components.Slider({ name : 'slide', time : 0.25, end : paintPrimary.pos, ease : luxe.tween.easing.Quad.easeOut }));

        // Create an effect similar to the block highlight one.
        var ent = new luxe.Visual({
            pos    : paintPrimary.pos.clone().addScalar(64),
            origin : new Vector(64, 64),
            size   : new Vector(128, 128),
            color  : new Color(1, 1, 1, 1),
            depth  : 3
        });

        ent.add(new components.AlphaFade({ name : 'fade_in' , time : 0.1, startAlpha : 0, endAlpha : 1 }));
        ent.add(new components.AlphaFade({ name : 'fade_out', time : 0.2, delay : 0.1, startAlpha : 1, endAlpha : 0 }));
        ent.add(new components.Scale({ name : 'scale', time : 0.1, factor : 1.1 }));
        ent.add(new components.DestroyTimer({ name : 'destroy', delay : 0.4 }));
    }

    private function onSecondaryPressed(_)
    {
        PuzzleState.color.currentColor = Secondary;

        // Slide the selector to this button.
        if (paintSelector.has('slide')) paintSelector.remove('slide');
        paintSelector.add(new components.Slider({ name : 'slide', time : 0.25, end : paintSecondary.pos, ease : luxe.tween.easing.Quad.easeOut }));

        // Create an effect similar to the block highlight one.
        var ent = new luxe.Visual({
            pos    : paintSecondary.pos.clone().addScalar(64),
            origin : new Vector(64, 64),
            size   : new Vector(128, 128),
            color  : new Color(1, 1, 1, 1),
            depth  : 3
        });

        ent.add(new components.AlphaFade({ name : 'fade_in' , time : 0.1, startAlpha : 0, endAlpha : 1 }));
        ent.add(new components.AlphaFade({ name : 'fade_out', time : 0.2, delay : 0.1, startAlpha : 1, endAlpha : 0 }));
        ent.add(new components.Scale({ name : 'scale', time : 0.1, factor : 1.1 }));
        ent.add(new components.DestroyTimer({ name : 'destroy', delay : 0.4 }));  
    }

    private function onExportClicked(_)
    {
        // 
        var puzzle : components.designer.PuzzleDesigner = cast puzzle.get('puzzle');
        var newGrid = new data.PuzzleGrid(puzzle.rows(), puzzle.columns());

        for (row in 0...puzzle.grid.data.length)
        {
            for (col in 0...puzzle.grid.data[row].length)
            {
                var designerCell = puzzle.grid.data[row][col];
                if (designerCell.state == Empty)
                {
                    newGrid.data[row][col].state = Destroyed;
                }
                else
                {
                    newGrid.data[row][col] = designerCell;
                }
            }
        }

        var pixels : snow.api.buffers.Uint8Array = null;
        if (puzzle.has('overlay'))
        {
            var tex = cast(puzzle.get('overlay'), components.designer.Overlay).texture;
            var arr = new snow.api.buffers.Uint8Array(tex.width * tex.height * 4);
            tex.fetch(arr, 0, 0, tex.width, tex.height);
            pixels = arr;
        }

        //utils.storage.PuzzleSaver.save(new data.PuzzleInfo('testPuzzle', 'Aidan Lee', 'A test puzzle!', newGrid, pixels));
        utils.storage.PuzzleStorage.save(new data.PuzzleInfo(Luxe.utils.uniquehash(),'testPuzzle', 'Aidan Lee', 'A test puzzle!', newGrid, pixels));

        // Create an effect similar to the block highlight one.
        var ent = new luxe.Visual({
            pos    : export.pos.clone().addScalar(64),
            origin : new Vector(64, 64),
            size   : new Vector(128, 128),
            color  : new Color(1, 1, 1, 1),
            depth  : 3
        });

        ent.add(new components.AlphaFade({ name : 'fade_in' , time : 0.1, startAlpha : 0, endAlpha : 1 }));
        ent.add(new components.AlphaFade({ name : 'fade_out', time : 0.2, delay : 0.1, startAlpha : 1, endAlpha : 0 }));
        ent.add(new components.Scale({ name : 'scale', time : 0.1, factor : 1.1 }));
        ent.add(new components.DestroyTimer({ name : 'destroy', delay : 0.4 }));    
    }
    */
}
