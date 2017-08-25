package utils.storage;

import haxe.io.Bytes;
import haxe.io.Path;
import data.PuzzleInfo;
import sys.FileSystem;
import sys.io.File;

class PuzzleStorage
{
    /**
     *  Returns an absolute path to the puzzle storage.
     *  @return String
     */
    public static function puzzleStorage() : String
    {
        return Path.join([ Path.directory(Sys.programPath()), 'assets', 'puzzles' ]);
    }

    /**
     *  Returns every puzzle found in the assets/puzzles folder.
     *  @return Array<PuzzleInfo>
     */
    public static function getUGPuzzles() : Array<PuzzleInfo>
    {
        var puzzles = new Array<PuzzleInfo>();

        for (file in FileSystem.readDirectory(puzzleStorage()))
        {
            if (!FileSystem.isDirectory(file) && Path.extension(file) == 'puzzle')
            {
                puzzles.push(load(file));
            }
        }

        return puzzles;
    }

    /**
     *  Serializes and compresses the provided PuzzleInfo class. The file is saved in the puzzle storage.
     *  The file name is the puzzles id and it's name.
     *  @param _info - The puzzle to save.
     */
    public static function save(_info : PuzzleInfo)
    {
        File.saveBytes(Path.join([ puzzleStorage(), Std.string(_info.id) + '-${_info.name}.puzzle' ]), compress(_info));
    }

    /**
     *  Decompresses and deserialized the provided puzzle returning a PuzzleInfo object.
     *  @param _puzzle - The name of the puzzle.
     *  @return PuzzleInfo
     */
    public static function load(_puzzle : String) : PuzzleInfo
    {
        return decompress(File.getBytes(Path.join([ puzzleStorage(), _puzzle ])));
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
