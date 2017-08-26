package ui.creators;

import luxe.Visual;
import luxe.Text;
import luxe.NineSlice;
import luxe.Sprite;
import luxe.Rectangle;
import luxe.Vector;
import luxe.Color;
import luxe.components.sprite.SpriteAnimation;
import game.PuzzleState;

class Game
{
    /**
     *  Create the in game UI.
     *  @return Visual
     */
    public static inline function createHUD() : Visual
    {
        var panel = new Visual({
            name  : 'panel_ui',
            pos   : new Vector(0, 0),
            size  : new Vector(128, 720),
            color : new Color().rgb(0x363636),
        });

        var pause = new Visual({
            name     : 'bttn_pause',
            parent   : panel,
            pos      : new Vector(0, 0),
            size     : new Vector(128, 128),
            geometry : Luxe.draw.texture({
                texture : Luxe.resources.texture('assets/images/ui/buttonPause.png')
            })
        });
        pause.add(new components.ui.Button({ name : 'button' }));
        pause.transform.world.auto_decompose = true;

        var paintPrimary = new Visual({
            name     : 'bttn_paintPrimary',
            parent   : panel,
            pos      : new Vector(0, 128),
            size     : new Vector(128, 128),
            color    : PuzzleState.color.colors.get(Primary)
        });
        paintPrimary.add(new components.ui.Button({ name : 'button' }));
        paintPrimary.transform.world.auto_decompose = true;

        var paintSecondary = new Visual({
            name     : 'bttn_paintSecondary',
            parent   : panel,
            pos      : new Vector(0, 256),
            size     : new Vector(128, 128),
            color    : PuzzleState.color.colors.get(Secondary)
        });
        paintSecondary.add(new components.ui.Button({ name : 'button' }));
        paintSecondary.transform.world.auto_decompose = true;

        var paintSelector = new Sprite({
            name    : 'bttn_paintSelector',
            parent  : panel,
            texture : Luxe.resources.texture('assets/images/ui/paintSelector.png'),
            pos     : paintPrimary.pos,
            size    : new Vector(128, 128),
            origin  : new Vector(0, 0),
        });
        paintSelector.transform.world.auto_decompose = true;
        
        var anim : SpriteAnimation = paintSelector.add(new SpriteAnimation({ name : 'animation' }));
        anim.add_from_json_object(Luxe.resources.json('assets/data/animations/paintSelector.json').asset.json);
        anim.animation = 'idle';
        anim.play();

        new Text({
            name : 'label_timer',
            parent : panel,
            text : '00:00',
            point_size : 24,
            pos : new Vector(64, 448),
            align : center,
            align_vertical : center
        });

        return panel;
    }

    /**
     *  Create the results panel for a successfully completed panel.
     *  @return Visual
     */
    public static inline function createResults() : Visual
    {
        var panel = new NineSlice({
            name    : 'panel_results',
            texture : Luxe.resources.texture('assets/images/ui/roundedPanel.png'),
            color   : new Color().rgb(0x333333),
            depth   : 8,
            top : 20, left : 20, bottom : 20, right : 20
        });
        panel.create(new Vector(0, 0), 544, 624);

        var bttnMenu = new NineSlice({
            parent  : panel,
            name    : 'bttn_menu',
            texture : Luxe.resources.texture('assets/images/ui/roundedButton.png'),
            depth   : 9,
            pos     : new Vector(20, 360),
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
                new Vector(300, 50)
            ],
            text : 'Return to Menu',
            align : center,
            align_vertical : center,
            point_size : 24,
            depth : 10
        }));
        bttnMenu.create(new Vector(16, 544), 432, 64);

        var bttnRestart = new NineSlice({
            parent  : panel,
            name    : 'bttn_restart',
            texture : Luxe.resources.texture('assets/images/ui/roundedButton.png'),
            depth   : 9,
            pos     : new Vector(20, 360),
            size    : new Vector(600, 80),
            top : 30, left : 30, bottom : 30, right : 30,
        });
        bttnRestart.add(new components.ui.NineSliceButton({
            name : 'button',
            uvs : [
                new Rectangle(0  , 0, 80, 80),
                new Rectangle(80 , 0, 80, 80),
                new Rectangle(160, 0, 80, 80)
            ],
            colors : [ new Color(), new Color().rgb(0xe7e7e7), new Color().rgb(0xe7e7e7) ]
        }));
        bttnRestart.create(new Vector(464, 544), 64, 64);

        return panel;
    }
}
