package storage;

import data.PuzzleInfo;

interface IStorage
{
    //public function setup() : Void;
    //public function cleanup() : Void;

    public function getUGPuzzles() : Array<PuzzleInfo>;
    public function saveUGPuzzle(_puzzle : PuzzleInfo) : Bool;
    public function loadUGPuzzle(_name : String) : PuzzleInfo;
    public function deleteUGPuzzle(_puzzle : PuzzleInfo) : Bool;
}
