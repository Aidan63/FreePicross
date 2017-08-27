package components;

import luxe.Component;
import luxe.Rectangle;
import luxe.Vector;
import luxe.Visual;
import luxe.Color;
import luxe.options.ComponentOptions;
import phoenix.geometry.QuadPackGeometry;
import phoenix.RenderTexture;
import phoenix.Batcher;

import components.Dimensions;
import components.Puzzle;
import data.IPuzzle;
import game.PuzzleState;

class Display extends Component
{
    /**
     *  This components entity cast to a visual type.
     */
    private var visual : Visual;

    /**
     *  The quad pack geometry to hold all of the cell quads.
     */
    private var brushedGeom : QuadPackGeometry;

    /**
     *  The quad pack geometry to hold all of the pencil quads.
     */
    private var penciledGeom : QuadPackGeometry;

    /**
     *  2D array holding all of the UUIDs for the cell packed quads in the grid.
     */
    private var brushedQuadUUIDs : Array<Array<Int>>;

    /**
     *  2D array holding all of the UUIDs for the pencil packed quads in the grid.
     */
    private var penciledQuadUUIDs : Array<Array<Int>>;

    /**
     *  The texture the brush and pencil quad packs will be drawn to.
     *  This texture will then be used for this components entity's texture.
     */
    private var targetTexture : RenderTexture;

    /**
     *  The batcher for the two quad pack geometries.
     */
    private var cellBatcher : Batcher;

    /**
     *  The size of the box the puzzle display will be restricted to.
     */
    private var boundary : Vector;

    public function new(_options : DisplayOptions)
    {
        super(_options);

        _options.boundary == null ? boundary = new Vector(Luxe.screen.width * 0.6, Luxe.screen.height * 0.6) : boundary = _options.boundary;
    }

    override public function onadded()
    {
        // Connect entity events
        entity.events.listen('cell.brushed' , onCellBrushed);
        entity.events.listen('cell.penciled', onCellPenciled);
        entity.events.listen('cell.removed' , onCellRemoved);
        entity.events.listen('cell.clean'   , onCellCleaned);

        visual = cast entity;

        if (has('dimensions') && has('puzzle'))
        {
            var size   : Dimensions = cast get('dimensions');
            var puzzle : IPuzzle    = cast get('puzzle');

            // Get the actual width and height of this puzzle as well as the cell size.
            var baseWidth  = 128 * puzzle.columns();
            var baseHeight = 128 * puzzle.rows();
            var scaledSize : Vector = aspectRationFit(baseWidth, baseHeight, boundary.x, boundary.y);
            size.cellSize = scaledSize.x / puzzle.columns();

            // Creates the render texture and batcher for the quad pack geometries.
            targetTexture = new RenderTexture({ id : 'rtt_displayCells', width : Math.round(scaledSize.x), height : Math.round(scaledSize.y) });

            cellBatcher = Luxe.renderer.create_batcher({ name : 'cell_batcher' });
            cellBatcher.view.viewport = new Rectangle(0, 0, baseWidth, baseHeight);
            cellBatcher.on(BatcherEventType.prerender , beforeRender.bind(_, targetTexture));
            cellBatcher.on(BatcherEventType.postrender, afterRender);

            // Create two quad pack geometries for the brushed and penciled cells and fill them with default quads.
            brushedGeom = new QuadPackGeometry({
                texture : Luxe.resources.texture('assets/images/cells.png'),
                batcher : cellBatcher
            });
            penciledGeom = new QuadPackGeometry({
                texture : Luxe.resources.texture('assets/images/cells.png'),
                batcher : cellBatcher
            });

            brushedQuadUUIDs = [ for (row in 0...puzzle.rows()) [ for (col in 0...puzzle.columns()) brushedGeom.quad_add({
                        x : col * size.cellSize,
                        y : row * size.cellSize,
                        w : size.cellSize,
                        h : size.cellSize,
                        color : new Color(0.4, 0.4, 0.4, 1),
                        uv    : new Rectangle(0, 0, 128, 128)
                    }) ] ];
            penciledQuadUUIDs = [ for (row in 0...puzzle.rows()) [ for (col in 0...puzzle.columns()) penciledGeom.quad_add({
                        x : col * size.cellSize,
                        y : row * size.cellSize,
                        w : size.cellSize,
                        h : size.cellSize,
                        color : new Color(0, 0, 0, 0),
                        uv    : new Rectangle(128, 0, 128, 128)
                    }) ] ];

            // Set our visual entity to have the rtt as a texture.
            visual.size = scaledSize;
            
            targetTexture.filter_mag = targetTexture.filter_min = nearest;

            visual.geometry = Luxe.draw.texture({
                texture : targetTexture,
                size    : visual.size,
                flipy   : true
            });

            setDisplayToActive();
        }
    }

    override public function onremoved()
    {
        entity.events.unlisten('cell.brushed');
        entity.events.unlisten('cell.penciled');
        entity.events.unlisten('cell.removed');
        entity.events.unlisten('cell.clean');

        // Set the visual geometry to a white box of the same size.
        visual.geometry = Luxe.draw.box({
            x : visual.pos.x,
            y : visual.pos.y,
            w : visual.size.x,
            h : visual.size.y
        });

        targetTexture.destroy();
        cellBatcher.destroy(true);
    }

    private function aspectRationFit(_srcWidth : Float, _srcHeight : Float, _maxWidth : Float, _maxHeight : Float) : Vector
    {
        var ratio = Math.min(_maxWidth / _srcWidth, _maxHeight / _srcHeight);
        return new Vector(_srcWidth * ratio, _srcHeight * ratio);
    }

    /**
     *  Changes the luxe renderers target to the provided render texture before the cell batcher is rendered.
     *  
     *  @param _batcher The batcher about to be rendered.
     *  @param _texture The texture to render all geometry in the batcher to.
     */
    private function beforeRender(_batcher : Batcher, _texture : RenderTexture)
    {
        Luxe.renderer.target = _texture;
        Luxe.renderer.clear(new Color(0, 0, 0, 0));
    }

    /**
     *  Resets the luxe renderer back to default after the cell batcher has been rendered.
     *  
     *  @param _batcher The batcher which was just rendered.
     */
    private function afterRender(_batcher : Batcher)
    {
        Luxe.renderer.target = null;
    }

    // Entity event functions

    private function onCellBrushed(_position : data.events.CellPosition)
    {
        var brushUUID  = brushedQuadUUIDs[_position.row][_position.column];
        var pencilUUID = penciledQuadUUIDs[_position.row][_position.column];

        brushedGeom.quad_color(brushUUID, PuzzleState.color.getLuxeColor());
        penciledGeom.quad_alpha(pencilUUID, 0);
    }

    private function onCellPenciled(_position : data.events.CellPosition)
    {
        var pencilUUID = penciledQuadUUIDs[_position.row][_position.column];
        penciledGeom.quad_color(pencilUUID, PuzzleState.color.getLuxeColor());
    }

    private function onCellRemoved(_position : data.events.CellPosition)
    {
        var brushUUID  = brushedQuadUUIDs[_position.row][_position.column];
        var pencilUUID = penciledQuadUUIDs[_position.row][_position.column];

        brushedGeom.quad_alpha(brushUUID, 0);
        penciledGeom.quad_alpha(pencilUUID, 0);
    }

    private function onCellCleaned(_position : data.events.CellPosition)
    {
        var brushUUID  = brushedQuadUUIDs[_position.row][_position.column];
        var pencilUUID = penciledQuadUUIDs[_position.row][_position.column];

        brushedGeom.quad_color(brushUUID, new Color().rgb(0x666666));
        penciledGeom.quad_color(pencilUUID, new Color(1, 1, 1, 0));
    }

    /**
     *  Loop over the active grid and set each cell in the display to represent it.
     */
    private function setDisplayToActive()
    {
        var debugPuzzle : IPuzzle = cast get('puzzle');
        var grid = debugPuzzle.active.data;

        for (row in 0...grid.length)
        {
            for (col in 0...grid[row].length)
            {
                var cell = grid[row][col];
                switch (cell.state)
                {
                    case Brushed:
                        PuzzleState.color.currentColor = cell.color;
                        onCellBrushed(new data.events.CellPosition(row, col));

                    case Destroyed:
                        onCellRemoved(new data.events.CellPosition(row, col));

                    default:
                }
            }
        }
    }
}

typedef DisplayOptions = {
    > ComponentOptions,
    @:optional var boundary : Vector;
}
