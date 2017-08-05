package utils.storage;

import haxe.io.Bytes;
import data.PuzzleInfo;
import data.PuzzleGrid;
import snow.api.buffers.Uint8Array;
import HaxeLow;

class PuzzleLoader
{
    private static var db : HaxeLow;

    /**
     *  Returns a PuzzleGrid object from the provided path to a serialized puzzle grid.
     *  @param _path The path to the serialized puzzle grid.
     *  @return PuzzleGrid object of the provided path or an empty 8x8 grid if the path was empty.
     */
    public static function load(_name : String) : PuzzleInfo
    {
        if (_name == "") return null;

        checkDB();

        var puzzles = db.col(utils.storage.DBPuzzleInfo);
        trace(puzzles.length);
        for (puzzle in puzzles)
        {
            trace(puzzle.name);
            if (puzzle.name != _name) continue;

            return new PuzzleInfo(
                puzzle.name,
                puzzle.author,
                puzzle.description,
                decompressGrid(puzzle.grid),
                decompressPixels(puzzle.pixels)
            );
        }

        return null;
    }

    public static function listAllPuzzles() : Array<String>
    {
        checkDB();

        return [];
    }

    private static function decompressGrid(_data : Bytes) : PuzzleGrid
    {
        var bytes = haxe.zip.Uncompress.run(_data);
        var strm  = new serialization.stream.StringInflateStream(bytes.toString());
        var infl  = new serialization.Inflater(strm);

        var data : PuzzleGrid = infl.unserialize();
        return data;
    }

    private static function decompressPixels(_data : Bytes) : Uint8Array
    {
        var bytes = haxe.zip.Uncompress.run(_data);
        var strm  = new serialization.stream.StringInflateStream(bytes.toString());
        var infl  = new serialization.Inflater(strm);

        var data : Uint8Array = infl.unserialize();
        return data;
    }

    private static function checkDB()
    {
        if (db == null)
        {
            var path = haxe.io.Path.join([ Sys.programPath(), 'assets', 'data', 'puzzle.json' ]);
            trace(path);
            db = new HaxeLow('/media/aidan/archive/projects/FreePicross/Picross/bin/linux64/assets/data/puzzles.json');
        }
    }
}
