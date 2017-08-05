package ui.game;

import luxe.Sprite;
import luxe.Visual;
import luxe.Color;
import luxe.Vector;
import luxe.Text;
import luxe.Scene;
import luxe.components.sprite.SpriteAnimation;
import game.PuzzleState;

class GameUI
{
    /**
     *  The entity which will be the parent and panel visual for all other game UI elements.
     */
    private var panel : Visual;

    /**
     *  The entity which will be the pause button.
     */
    private var pause : Visual;

    /**
     *  The entity which will be the button to select the primary paint.
     */
    private var paintPrimary : Visual;

    /**
     *  The entity which will be the button to select the secondary paint.
     */
    private var paintSecondary : Visual;

    /**
     *  animated sprite indicator of the currently selected paint.
     */
    private var paintSelector : Sprite;

    /**
     *  The text object which will display the current time in the puzzle.
     */
    private var timer : Text;

    /**
     *  The scene which all ui elements will belong to.
     */
    public var scene : Scene;

    public function new()
    {
        scene = new Scene('ui');

        panel = new Visual({
            name  : 'ui_panel',
            pos   : new Vector(-128, 0),
            size  : new Vector(128, Luxe.camera.viewport.h),
            color : new Color().rgb(0x363636),
            scene : scene
        });

        pause = new Visual({
            name     : 'ui_pause',
            parent   : panel,
            pos      : new Vector(0, 0),
            size     : new Vector(128, 128),
            scene    : scene,
            geometry : Luxe.draw.texture({
                texture : Luxe.resources.texture('assets/images/ui/buttonPause.png')
            })
        });
        pause.add(new components.ui.Button({ name : 'button' }));

        paintPrimary = new Visual({
            name     : 'ui_paintPrimary',
            parent   : panel,
            pos      : new Vector(0, 128),
            size     : new Vector(128, 128),
            scene    : scene,
            color    : PuzzleState.color.colors.get(Primary)
        });
        paintPrimary.add(new components.ui.Button({ name : 'button' }));

        paintSecondary = new Visual({
            name     : 'ui_paintSecondary',
            parent   : panel,
            pos      : new Vector(0, 256),
            size     : new Vector(128, 128),
            scene    : scene,
            color    : PuzzleState.color.colors.get(Secondary)
        });
        paintSecondary.add(new components.ui.Button({ name : 'button' }));

        paintSelector = new Sprite({
            name    : 'ui_paintSelector',
            parent  : panel,
            texture : Luxe.resources.texture('assets/images/ui/paintSelector.png'),
            pos     : paintPrimary.pos,
            size    : new Vector(128, 128),
            origin  : new Vector(0, 0),
            scene   : scene
        });
        var anim : SpriteAnimation = paintSelector.add(new SpriteAnimation({ name : 'animation' }));
        anim.add_from_json_object(Luxe.resources.json('assets/data/animations/paintSelector.json').asset.json);
        anim.animation = 'idle';
        anim.play();

        timer = new Text({
            name : 'ui_timer',
            parent : panel,
            text : PuzzleState.timer.getFormattedTime(),
            point_size : 24,
            pos : new Vector(64, 448),
            align : center,
            align_vertical : center
        });
        timer.add(new components.ui.UpdateTimer({ name : 'ui_timer_updater' }));

        pause         .events.listen('clicked', onPausePressed);
        paintPrimary  .events.listen('clicked', onPrimaryPressed);
        paintSecondary.events.listen('clicked', onSecondaryPressed);
    }

    public function moveIn()
    {
        panel.add(new components.Slider({ name : 'slide_in', time : 0.25, end : new Vector(0, 0), ease : luxe.tween.easing.Quad.easeOut }));
    }
    public function moveOut()
    {
        panel.add(new components.Slider({ name : 'slide_out', time : 0.25, end : new Vector(-128, 0), ease : luxe.tween.easing.Quad.easeIn }));
        panel.add(new components.DestroyTimer({ name : 'destroy', delay : 0.25 }));
    }

    private function onPausePressed(_)
    {
        // Create an effect similar to the block highlight one.
        var ent = new luxe.Visual({
            pos    : pause.pos.clone().addScalar(64),
            origin : new Vector(64, 64),
            size   : new Vector(128, 128),
            color  : new Color(1, 1, 1, 1),
            depth  : 3,
            scene  : scene
        });

        ent.add(new components.AlphaFade({ name : 'fade_in' , time : 0.1, startAlpha : 0, endAlpha : 1 }));
        ent.add(new components.AlphaFade({ name : 'fade_out', time : 0.2, delay : 0.1, startAlpha : 1, endAlpha : 0 }));
        ent.add(new components.Scale({ name : 'scale', time : 0.1, factor : 1.1 }));
        ent.add(new components.DestroyTimer({ name : 'destroy', delay : 0.4 }));
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
            depth  : 3,
            scene  : scene
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
            depth  : 3,
            scene  : scene
        });

        ent.add(new components.AlphaFade({ name : 'fade_in' , time : 0.1, startAlpha : 0, endAlpha : 1 }));
        ent.add(new components.AlphaFade({ name : 'fade_out', time : 0.2, delay : 0.1, startAlpha : 1, endAlpha : 0 }));
        ent.add(new components.Scale({ name : 'scale', time : 0.1, factor : 1.1 }));
        ent.add(new components.DestroyTimer({ name : 'destroy', delay : 0.4 }));  
    }
}
