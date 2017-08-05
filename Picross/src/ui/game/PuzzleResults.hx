package ui.game;

import luxe.Visual;
import luxe.Color;
import luxe.Vector;

class PuzzleResults
{
    private var panel : Visual;
    private var bttnMenu : Visual;
    private var bttnRestart : Visual;

    public function new()
    {
        panel = new Visual({
            name  : 'panel',
            pos   : new Vector(Luxe.camera.viewport.w, 48),
            size  : new Vector(544, 624),
            color : new Color().rgb(0x363636)
        });

        bttnMenu = new Visual({
            name   : 'bttn_menu',
            parent : panel,
            pos    : new Vector(16, 544),
            size   : new Vector(432, 64),
            color  : new Color().rgb(0x8dd069),
            depth  : 2
        });
        bttnMenu.add(new components.ui.Button({ name : 'button' }));

        bttnRestart = new Visual({
            name   : 'bttn_menu',
            parent : panel,
            pos    : new Vector(464, 544),
            size   : new Vector(64, 64),
            color  : new Color().rgb(0xea3636),
            depth  : 2
        });
        bttnRestart.add(new components.ui.Button({ name : 'button' }));

        bttnMenu.events.listen('clicked', function(_) {
            // Create an effect similar to the block highlight one.
            var ent = new luxe.Visual({
                parent : bttnMenu,
                pos    : new Vector(216, 32),
                origin : new Vector(216, 32),
                size   : new Vector(432, 64),
                color  : new Color(1, 1, 1, 1),
                depth  : 3,
            });

            ent.add(new components.AlphaFade({ name : 'fade_in' , time : 0.1, startAlpha : 0, endAlpha : 1 }));
            ent.add(new components.AlphaFade({ name : 'fade_out', time : 0.2, delay : 0.1, startAlpha : 1, endAlpha : 0 }));
            ent.add(new components.Scale({ name : 'scale', time : 0.1, targetW : 8, targetH : 8 }));
            ent.add(new components.DestroyTimer({ name : 'destroy', delay : 0.4 }));
        });
        bttnRestart.events.listen('clicked', function(_) {
            // Create an effect similar to the block highlight one.
            var ent = new luxe.Visual({
                parent : bttnRestart,
                pos    : new Vector(32, 32),
                origin : new Vector(32, 32),
                size   : new Vector(64, 64),
                color  : new Color(1, 1, 1, 1),
                depth  : 3,
            });

            ent.add(new components.AlphaFade({ name : 'fade_in' , time : 0.1, startAlpha : 0, endAlpha : 1 }));
            ent.add(new components.AlphaFade({ name : 'fade_out', time : 0.2, delay : 0.1, startAlpha : 1, endAlpha : 0 }));
            ent.add(new components.Scale({ name : 'scale', time : 0.1, targetW : 8, targetH : 8 }));
            ent.add(new components.DestroyTimer({ name : 'destroy', delay : 0.4 }));
        });
    }

    public function moveIn()
    {
        panel.add(new components.Slider({ name : 'slide_in', time : 0.5, end : new Vector(688, 48), ease : luxe.tween.easing.Quad.easeOut }));
    }
}
