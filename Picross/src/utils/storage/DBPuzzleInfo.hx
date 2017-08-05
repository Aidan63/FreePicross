package utils.storage;

import HaxeLow;
import haxe.io.Bytes;

class DBPuzzleInfo
{
    /**
     *  The unique ID for this puzzle.
     */
    public var id : String;

    /**
     *  Name of this puzzle.
     */
    public var name : String;

    /**
     *  The compressed and serialized PuzzleGrid data.
     */
    public var grid : Bytes;

    /**
     *  The compressed and serialized array of ints for pixel data.
     */
    public var pixels : Bytes;

    /**
     *  The author of the puzzle.
     */
    public var author : String;

    /**
     *  The puzzle description.
     */
    public var description : String;

    public function new(_name : String, _author : String, _description : String, _grid : Bytes, _pixels : Bytes)
    {
        id          = HaxeLow.uuid();
        name        = _name;
        author      = _author;
        description = _description;
        grid        = _grid;
        pixels      = _pixels;
    }

    public static function create(_info : data.PuzzleInfo) : DBPuzzleInfo
    {
        return new DBPuzzleInfo(
            _info.name,
            _info.author,
            _info.description,
            compress(_info.grid),
            compress(_info.pixels)
        );
    }

    private static function compress(_data : Dynamic) : Bytes
    {
        var def = new serialization.Deflater({ compressStrings : true });
        def.serialize(_data);

        return haxe.zip.Compress.run(Bytes.ofString(def.toString()), 9);
    }
}
