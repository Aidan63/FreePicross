
import storage.IStorage;

class Picross
{
    public static var storage : IStorage;

    public static function init()
    {
        #if sys
            storage = new storage.SysStorage();
        #else
            storage = new storage.JsStorage();
        #end
    }
}
