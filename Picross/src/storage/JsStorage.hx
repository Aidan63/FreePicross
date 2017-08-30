package storage;

import js.Browser;
import js.html.Storage;
import haxe.Json;

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

    private function decompress(_structure : String) : Array<PuzzleInfo>
    {
        var structure : Array<PuzzleInfo> = Json.parse(_structure);
        trace(structure);
        return structure;
    }

    private function compress(_structure : Array<PuzzleInfo>)
    {
        /*
        var serializer = new haxe.Serializer();
        serializer.serialize(_structure);

        trace(serializer.toString());
        */

        if (storage != null)
        {
            storage.setItem('ugc_puzzles', Json.stringify(_structure));
        }
    }
}
