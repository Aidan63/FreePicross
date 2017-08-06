package utils.storage;

import haxe.io.Bytes;
import haxe.io.Path;
import data.PuzzleInfo;

class PuzzleStorage
{
    public static function puzzleStorage() : String
    {
        return Path.join([ Path.directory(Sys.programPath()), 'assets', 'puzzles' ]);
    }

    public static function save(_info : PuzzleInfo)
    {
        sys.io.File.saveBytes(Path.join([ puzzleStorage(), Std.string(_info.id) + '.puzzle' ]), compress(_info));
    }

    public static function load(_puzzle : String) : PuzzleInfo
    {
        return decompress(sys.io.File.getBytes(Path.join([ puzzleStorage(), _puzzle + '.puzzle' ])));
    }

    private static function compress(_info : PuzzleInfo) : Bytes
    {
        var defl = new serialization.Deflater({ compressStrings : true });
        defl.serialize(_info);

        return haxe.zip.Compress.run(Bytes.ofString(defl.toString()), 9);
    }

    private static function decompress(_bytes : Bytes) : PuzzleInfo
    {
        var bytes = haxe.zip.Uncompress.run(_bytes);
        var strm = new serialization.stream.StringInflateStream(bytes.toString());
        var infl = new serialization.Inflater(strm);
        var puzzle : PuzzleInfo = infl.unserialize();

        return puzzle;
    }
}
