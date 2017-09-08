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

    /**
     *  Returns all puzzles in the browser storage or an empty array.
     *  @return Array<PuzzleInfo>
     */
    public function getUGPuzzles() : Array<PuzzleInfo>
    {
        if (storage == null || storage.getItem('ugc_puzzles') == null) return new Array<PuzzleInfo>();

        return decompress(storage.getItem('ugc_puzzles'));
    }

    /**
     *  Save the provided puzzle class.
     *  Replaces any puzzle with the same ID else pushes it to the end of the array.
     *  The entire array is then serialized and put in browser storage.
     *  
     *  @param _puzzle - The puzzle to save.
     *  @return Bool
     */
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

    /**
     *  Returns a puzzle with the provided name or null.
     *  @param _name - The puzzle to look for.
     *  @return PuzzleInfo
     */
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

    /**
     *  Attempts to unserialize the provided string into an array of puzzles.
     *  @param _structure - The string to unserialize.
     *  @return Array<PuzzleInfo>
     */
    private function decompress(_structure : String) : Array<PuzzleInfo>
    {
        var strm = new serialization.stream.StringInflateStream(_structure);
        var infl = new serialization.Inflater(strm);
        var structure : Array<PuzzleInfo> = infl.unserialize();

        return structure;
    }

    /**
     *  Serializes the provided array of puzzles and stores them in the browser storage if possible.
     *  @param _structure - The puzzles to serialize.
     */
    private function compress(_structure : Array<PuzzleInfo>)
    {
        var defl = new serialization.Deflater({ compressStrings : true });
        defl.serialize(_structure);

        if (storage != null) storage.setItem('ugc_puzzles', defl.toString());
    }
}
