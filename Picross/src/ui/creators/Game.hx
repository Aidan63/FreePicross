package ui.creators;

import luxe.Visual;
import luxe.Text;
import luxe.Sprite;
import luxe.Vector;
import luxe.Color;
import luxe.components.sprite.SpriteAnimation;
import game.PuzzleState;

class Game
{
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
}
