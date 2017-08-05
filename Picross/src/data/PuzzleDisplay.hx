package data;

import luxe.Visual;
import phoenix.Batcher;
import phoenix.RenderTexture;
import phoenix.geometry.Geometry;

class PuzzleDisplay
{
    /**
     *  2D array of all of the brushed cell geometries.
     */
    public var brushedCells : Array<Array<Geometry>>;

    /**
     *  2D array of all of the penciled cell geometries.
     */
    public var penciledCells : Array<Array<Geometry>>;

    /**
     *  The geometry that the render texture will be drawn to.
     */
    public var display : Visual;

    /**
     *  The texture the cell geometries will be drawn to.
     */
    public var targetTexture : RenderTexture;

    /**
     *  The batcher the cell geometries will use.
     */
    public var batcher : Batcher;

    public function new()
    {
        brushedCells  = new Array<Array<Geometry>>();
        penciledCells = new Array<Array<Geometry>>();
    }
}
