package data;

import luxe.importers.texturepacker.TexturePackerData;
import luxe.importers.texturepacker.TexturePackerJSON;

class Atlas
{
    public var atlases(default, null) : Map<String, TexturePackerData>;

    public function new()
    {
        atlases = new Map<String, TexturePackerData>();
        atlases.set('ui', TexturePackerJSON.parse(Luxe.resources.json('assets/data/ui.json').asset.json));
    }

    public function getFrame(_atlas : String, _frame : String) : TexturePackerFrame
    {
        return atlases.get(_atlas).frame(_frame);
    }
}
