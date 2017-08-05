package utils;

import haxe.Http;
import haxe.io.Bytes;
import snow.systems.assets.Asset;
import snow.api.buffers.Uint8Array;

class Resources
{
    public var onLoaded : Void -> Void;
    public var onError : String -> Void;

    public function new()
    {
        onLoaded = onDefaultLoader;
        onError  = onDefaultError;
    }

    public function loadFromURL(_url : String, _resourceName : String)
    {
        var req = new Http(_url);
        req.onData = function(_data : String) {
            var bytes   = Bytes.ofString(_data);
            var buff    = new Uint8Array(bytes.length);
            buff.buffer = [ for (i in 0...bytes.length) bytes.get(i) ];

            handleData(buff, _resourceName);
        };
        req.onError = onError;
        req.request();
    }

    public function loadFromFile(_path : String, _resourceName : String)
    {
        Luxe.snow.io.data_load(_path).then(handleData.bind(_, _resourceName)).error(onError);
    }

    private function handleData(_data : Uint8Array, _resourceName : String)
    {
        var load = Luxe.snow.assets.image_from_bytes(_resourceName, _data);
        load.then(function(_assets : AssetImage) {
            // Remove any existing texture with the same resource ID
            if (Luxe.resources.has(_resourceName))
            {
                var res = Luxe.resources.get(_resourceName);
                Luxe.resources.remove(res);
            }

            // Track the new resource.
            Luxe.resources.add(new phoenix.Texture({
                id : _resourceName,
                width : _assets.image.width_actual,
                height : _assets.image.height_actual,
                pixels : _assets.image.pixels
            }));

            onLoaded();
        });
    }

    private function onDefaultLoader()
    {
        trace('loaded');
    }

    private function onDefaultError(_)
    {
        trace('error');
    }
}
