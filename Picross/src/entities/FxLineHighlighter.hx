package entities;

import luxe.Visual;
import luxe.Color;

enum Orientation {
    Horizontal;
    Vertical;
}

class FxLineHighlighter extends Visual
{
    private var orientation : Orientation;
    private var startGradient : Visual;
    private var endGradient : Visual;
    private var alpha : Float;

    private var transparent : Color;
    private var varyingAlpha : Color;

    public function new(_orientation : Orientation, _x : Float, _y : Float, _width : Float, _height : Float)
    {
        super({
            depth : 2,
            color : new Color(1, 1, 1, 0),
            geometry : Luxe.draw.box({
                x : _x,
                y : _y,
                w : _width,
                h : _height
            })
        });

        orientation = _orientation;
        alpha = 0;

        if (orientation == Horizontal)
        {
            startGradient = new Visual({
                depth : 2,
                geometry : Luxe.draw.box({
                    x : _x - (_height * 1.5),
                    y : _y,
                    w : _height * 1.5,
                    h : _height
                })
            });
            endGradient = new Visual({
                depth : 2,
                geometry : Luxe.draw.box({
                    x : _x + _width,
                    y : _y,
                    w : _height * 1.5,
                    h : _height
                })
            });
        }
        else
        {
            startGradient = new Visual({
                depth : 2,
                geometry : Luxe.draw.box({
                    x : _x,
                    y : _y - (_width * 1.5),
                    w : _width,
                    h : _width * 1.5
                })
            });
            endGradient = new Visual({
                depth : 2,
                geometry : Luxe.draw.box({
                    x : _x,
                    y : _y + _height,
                    w : _width,
                    h : _width * 1.5
                })
            });
        }
    }

    override public function init()
    {
        varyingAlpha = new Color(1, 1, 1, 0);
        transparent  = new Color(1, 1, 1, 0);
        setAlphas();

        luxe.tween.Actuate.tween(this, 0.2, { alpha : 1 }).onUpdate(function() {
            varyingAlpha.a = alpha;
        }).onComplete(function() {
            luxe.tween.Actuate.tween(this, 0.4, { alpha : 0 }).onUpdate(function() {
                varyingAlpha.a = alpha;
            }).onComplete(function() {
                startGradient.destroy();
                endGradient.destroy();
                destroy();
            });
        });
    }

    private function setAlphas()
    {
        color = varyingAlpha;

        if (orientation == Horizontal)
        {
            startGradient.geometry.vertices[0].color = transparent;
            startGradient.geometry.vertices[3].color = transparent;
            startGradient.geometry.vertices[4].color = transparent;
            startGradient.geometry.vertices[1].color = varyingAlpha;
            startGradient.geometry.vertices[2].color = varyingAlpha;
            startGradient.geometry.vertices[5].color = varyingAlpha;

            endGradient.geometry.vertices[0].color = varyingAlpha;
            endGradient.geometry.vertices[3].color = varyingAlpha;
            endGradient.geometry.vertices[4].color = varyingAlpha;
            endGradient.geometry.vertices[1].color = transparent;
            endGradient.geometry.vertices[2].color = transparent;
            endGradient.geometry.vertices[5].color = transparent;
        }
        else
        {
            startGradient.geometry.vertices[0].color = transparent;
			startGradient.geometry.vertices[1].color = transparent;
			startGradient.geometry.vertices[4].color = transparent;
			startGradient.geometry.vertices[2].color = varyingAlpha;
			startGradient.geometry.vertices[3].color = varyingAlpha;
            startGradient.geometry.vertices[5].color = varyingAlpha;

            endGradient.geometry.vertices[0].color = varyingAlpha;
			endGradient.geometry.vertices[1].color = varyingAlpha;
			endGradient.geometry.vertices[4].color = varyingAlpha;
			endGradient.geometry.vertices[2].color = transparent;
			endGradient.geometry.vertices[3].color = transparent;
            endGradient.geometry.vertices[5].color = transparent;
        }
    }
}
