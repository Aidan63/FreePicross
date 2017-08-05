package data.states;

class DesignerTextureSize
{
    public var width : Int;
    public var height : Int;
    public var texture : phoenix.Texture;

    public function new(_width : Int, _height : Int, _texture : phoenix.Texture)
    {
        width   = _width;
        height  = _height;
        texture = _texture;
    }
}
