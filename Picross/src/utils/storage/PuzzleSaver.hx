package utils.storage;

import haxe.io.Bytes;
import data.PuzzleInfo;
import HaxeLow;

class PuzzleSaver
{
    private static var db : HaxeLow;

    /**
     *  Serializes and compresses the provided puzzle grid and saves it at the provided location on disk.
     *  @param _puzzle The puzzle to serialize.
     *  @param _path The location to save it.
     */
    public static function save(_info : PuzzleInfo)
    {
        checkDB();

        var puzzles = db.idCol(DBPuzzleInfo);
        puzzles.push(DBPuzzleInfo.create(_info));
        db.save();
    }

    /**
     *  Returns a compressed version of the provided bytes.
     *  @param _input The bytes to compress.
     *  @return The compressed bytes.
     */
    private static function compress(_input : Bytes) : Bytes
    {
        return haxe.zip.Compress.run(_input, 9);
    }

    private static function checkDB()
    {
        if (db == null) db = new HaxeLow('puzzles.json');
    }
}
