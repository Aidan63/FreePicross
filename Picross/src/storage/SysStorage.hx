package storage;

import haxe.io.Bytes;
import haxe.io.Path;
import sys.FileSystem;
import sys.io.File;

import data.PuzzleInfo;
import storage.IStorage;

class SysStorage implements IStorage
{
    public function new() { }

    /**
     *  Deserializes all files with the .puzzle extension found in the assets/puzzles/ folder.
     *  @return Array<PuzzleInfo>
     */
    public function getUGPuzzles() : Array<PuzzleInfo>
    {
        var puzzles = new Array<PuzzleInfo>();

        for (file in FileSystem.readDirectory(puzzleStorage()))
        {
            if (!FileSystem.isDirectory(file) && Path.extension(file) == 'puzzle')
            {
                puzzles.push(loadUGPuzzle(file));
            }
        }

        return puzzles;
    }

    public function saveUGPuzzle(_puzzle : PuzzleInfo)
    {
        File.saveBytes(Path.join([ puzzleStorage(), Std.string(_puzzle.id) + '-${_puzzle.name}.puzzle' ]), compress(_puzzle));
        return true;
    }

    public function loadUGPuzzle(_name : String) : PuzzleInfo
    {
        return decompress(File.getBytes(Path.join([ puzzleStorage(), _name ])));
    }

    /**
     *  Returns an absolute path to the puzzle storage.
     *  @return String
     */
    private function puzzleStorage() : String
    {
        return Path.join([ Path.directory(Sys.programPath()), 'assets', 'puzzles' ]);
    }

    /**
     *  Takes a PuzzleInfo class and returns bytes of a compressed serialized version.
     *  @param _info - The puzzle info the compress.
     *  @return Bytes
     */
    private function compress(_info : PuzzleInfo) : Bytes
    {
        var defl = new serialization.Deflater({ compressStrings : true });
        defl.serialize(_info);

        return haxe.zip.Compress.run(Bytes.ofString(defl.toString()), 9);
    }

    /**
     *  Takes bytes and returns a decompress and deserialized puzzle info class.
     *  @param _bytes - The bytes to decompress.
     *  @return PuzzleInfo
     */
    private function decompress(_bytes : Bytes) : PuzzleInfo
    {
        var bytes = haxe.zip.Uncompress.run(_bytes);
        var strm = new serialization.stream.StringInflateStream(bytes.toString());
        var infl = new serialization.Inflater(strm);
        var puzzle : PuzzleInfo = infl.unserialize();

        return puzzle;
    }
}
