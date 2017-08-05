package utils.storage;

import data.PuzzleGrid;
import HaxeLow;

class PuzzleLoader
{
    private static var db : HaxeLow;

    /**
     *  Returns a PuzzleGrid object from the provided path to a serialized puzzle grid.
     *  @param _path The path to the serialized puzzle grid.
     *  @return PuzzleGrid object of the provided path or an empty 8x8 grid if the path was empty.
     */
    public static function load(_path : String) : PuzzleGrid
    {
        if (_path == "") return new PuzzleGrid(8, 8);

        var strm = new serialization.stream.StringInflateStream(decompress(_path));
        var infl = new serialization.Inflater(strm);

        var grid : PuzzleGrid = infl.unserialize();
        return grid;
    }

    public static function listAllPuzzles() : Array<String>
    {
        checkDB();

        return [];

        /*
        var puzzleNames = new Array<String>();
        for (puzzle in db.idCol(PuzzleInfo))
        {
            puzzleNames.push(puzzle.name);
        }

        return puzzleNames;
        */
    }

    /**
     *  Decompresses the puzzle found at the provided path.
     *  @param _path The path to the puzzle on disk.
     *  @return String of the uncompressed puzzle bytes.
     */
    private static function decompress(_path) : String
    {
        //var bytes = haxe.zip.Uncompress.run(sys.io.File.getBytes(_path));
        var bytes = haxe.zip.Uncompress.run(Luxe.resources.bytes('assets/puzzles/ics.puzzle').asset.bytes.toBytes());
        return bytes.toString();
    }

    private static function checkDB()
    {
        if (db == null)
        {
            db = new HaxeLow('puzzles.json');
        }
    }
}
