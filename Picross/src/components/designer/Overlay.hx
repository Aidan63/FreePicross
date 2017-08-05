package components.designer;

import luxe.Component;
import luxe.Visual;
import luxe.Color;
import luxe.options.ComponentOptions;

class Overlay extends Component
{
    public var texture : phoenix.Texture;
    public var visual : Visual;

    public function new(_options : OverlayOptions)
    {
        super(_options);
        texture = _options.texture;
    }

    override public function onadded()
    {
        texture.filter_mag = texture.filter_min = nearest;

        var parent : Visual = cast entity;
        
        visual = new Visual({
            name    : 'overlay_image',
            pos     : parent.pos,
            size    : parent.size,
            origin  : parent.origin,
            texture : texture,
            color   : new Color(1, 1, 1, 0.5)
        });
    }

    override public function onremoved()
    {
        //visual.destroy();
    }
}

typedef OverlayOptions = {
    > ComponentOptions,
    var texture : phoenix.Texture;
}
