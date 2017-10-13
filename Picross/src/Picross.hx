
import storage.IStorage;
import data.Atlas;

class Picross
{
    public static var storage : IStorage;
    public static var atlas : Atlas;

    public static function init()
    {
        #if sys
            storage = new storage.SysStorage();
        #else
            storage = new storage.JsStorage();
        #end

        atlas = new Atlas();
    }
}
