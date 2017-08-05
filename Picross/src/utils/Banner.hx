package utils;

import luxe.Sprite;
import luxe.Vector;
import luxe.Color;

class Banner
{
    public static function create(_text : String, _stayingTime : Float)
    {
        var geom : Int = Math.ceil(Luxe.screen.width / 32) + 1;
        for (i in 0...geom)
        {
            var bubblesUp = new luxe.Sprite({
                depth   : 5,
                texture : Luxe.resources.texture('assets/images/bubblesUp.png'),
                origin  : new Vector(0, 0),
                pos     : new Vector(32 * i, Luxe.screen.height),
                size    : new Vector(32, 256),
                color   : new Color().rgb(0x88dfff),
            });

            var anim = bubblesUp.add(new luxe.components.sprite.SpriteAnimation({ name : 'anim' }));
            anim.add_from_json_object(Luxe.resources.json('assets/data/animations/bubbleUp.json').asset.json);
            anim.animation = 'loop';
            anim.play();

            bubblesUp.add(new components.Slider({ name : 'slide_in', time : 0.5, end : new Vector(32 * i, 240), ease : luxe.tween.easing.Quad.easeOut }));
            bubblesUp.add(new components.AlphaFade({ name : 'fade_in' , time : 0.5, startAlpha : 0, endAlpha : 1 }));
            bubblesUp.add(new components.AlphaFade({ name : 'fade_out', time : 0.5, startAlpha : 1, endAlpha : 0, delay : _stayingTime + 0.5 }));
            bubblesUp.add(new components.DestroyTimer({ name : 'destroy', delay : _stayingTime + 1 }));

            var bubblesDown = new luxe.Sprite({
                depth   : 5,
                texture : Luxe.resources.texture('assets/images/bubblesDown.png'),
                origin  : new Vector(0, 0),
                pos     : new Vector(32 * i, -256),
                size    : new Vector(32, 256),
                color   : new Color().rgb(0x88dfff),
            });

            var anim = bubblesDown.add(new luxe.components.sprite.SpriteAnimation({ name : 'anim' }));
            anim.add_from_json_object(Luxe.resources.json('assets/data/animations/bubbleDown.json').asset.json);
            anim.animation = 'loop';
            anim.play();

            bubblesDown.add(new components.Slider({ name : 'slide_in', time : 0.5, end : new Vector(32 * i, 496), ease : luxe.tween.easing.Quad.easeOut }));
            bubblesDown.add(new components.AlphaFade({ name : 'fade_in' , time : 0.5, startAlpha : 0, endAlpha : 1 }));
            bubblesDown.add(new components.AlphaFade({ name : 'fade_out', time : 0.5, startAlpha : 1, endAlpha : 0, delay : _stayingTime + 0.5 }));
            bubblesDown.add(new components.DestroyTimer({ name : 'destroy', delay : _stayingTime + 1 }));
        }

        var text = new luxe.Text({
            font  : Luxe.resources.font('assets/fonts/odin.fnt'),
            text  : _text,
            pos   : new Vector(640, 496),
            align : center,
            depth : 6,
            align_vertical : center,
            point_size     : 64
        });
        text.add(new components.AlphaFade({ name : 'fade_in' , time : 0.5, startAlpha : 0, endAlpha : 1 }));
        text.add(new components.AlphaFade({ name : 'fade_out', time : 0.5, startAlpha : 1, endAlpha : 0, delay : _stayingTime + 0.5 }));
        text.add(new components.DestroyTimer({ name : 'destroy', delay : _stayingTime + 1 }));
    }
}
