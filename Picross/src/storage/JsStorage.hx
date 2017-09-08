package storage;

import js.Browser;
import js.html.Storage;

import data.PuzzleInfo;
import storage.IStorage;

class JsStorage implements IStorage
{
    /**
     *  The local storage for the domain.
     */
    private var storage : Storage;

    public function new()
    {
        storage = Browser.getLocalStorage();
    }

    public function getUGPuzzles() : Array<PuzzleInfo>
    {
        if (storage == null || storage.getItem('ugc_puzzles') == null) return new Array<PuzzleInfo>();

        return decompress(storage.getItem('ugc_puzzles'));
    }

    public function saveUGPuzzle(_puzzle : PuzzleInfo) : Bool
    {
        var structure = getUGPuzzles();
        for (puzzle in structure)
        {
            if (puzzle.id == _puzzle.id)
            {
                puzzle = _puzzle;
                compress(structure);
                return true;
            }
        }

        structure.push(_puzzle);
        compress(structure);

        return true;
    }

    public function loadUGPuzzle(_name : String) : PuzzleInfo
    {
        for (puzzle in getUGPuzzles())
        {
            if (puzzle.name == _name) return puzzle;
        }

        return null;
    }

    public function deleteUGPuzzle(_puzzle : PuzzleInfo) : Bool
    {
        return false;
    }

    private function decompress(_structure : String) : Array<PuzzleInfo>
    {
        var strm = new serialization.stream.StringInflateStream(_structure);
        var infl = new serialization.Inflater(strm);
        var structure : Array<PuzzleInfo> = infl.unserialize();

        return structure;
    }

    private function compress(_structure : Array<PuzzleInfo>)
    {
        var defl = new serialization.Deflater({ compressStrings : true });
        defl.serialize(_structure);

        if (storage != null) storage.setItem('ugc_puzzles', defl.toString());
    }
}
