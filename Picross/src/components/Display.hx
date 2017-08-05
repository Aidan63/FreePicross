package components;

import luxe.Component;
import luxe.Rectangle;
import luxe.Vector;
import luxe.Visual;
import luxe.Color;
import phoenix.geometry.QuadPackGeometry;

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
            var scaledSize : Vector = aspectRationFit(baseWidth, baseHeight, Luxe.screen.width * 0.6, Luxe.screen.height * 0.6);
            size.cellSize = scaledSize.x / puzzle.columns();

            // Create two quad pack geometries for the brushed and penciled cells and fill them with default quads.
            brushedGeom = new QuadPackGeometry({
                texture : Luxe.resources.texture('assets/images/cell.png'),
                batcher : Luxe.renderer.batcher
            });
            penciledGeom = new QuadPackGeometry({
                texture : Luxe.resources.texture('assets/images/pencil.png'),
                batcher : Luxe.renderer.batcher
            });

            brushedQuadUUIDs = [ for (row in 0...puzzle.rows()) [ for (col in 0...puzzle.columns()) brushedGeom.quad_add({
                        x : col * size.cellSize,
                        y : row * size.cellSize,
                        w : size.cellSize,
                        h : size.cellSize,
                        color : new Color().rgb(0x666666),
                        uv    : new Rectangle(0, 0, 128, 128)
                    }) ] ];
            penciledQuadUUIDs = [ for (row in 0...puzzle.rows()) [ for (col in 0...puzzle.columns()) penciledGeom.quad_add({
                        x : col * size.cellSize,
                        y : row * size.cellSize,
                        w : size.cellSize,
                        h : size.cellSize,
                        color : new Color(0, 0, 0, 0),
                        uv    : new Rectangle(0, 0, 128, 128)
                    }) ] ];

            // Set our visual entity to have the brushed quad pack geom.
            // Both brush and pencil quad packs should probably go into an RTT then set that to the visual instead.
            visual.pos      = Luxe.screen.mid.add_xyz(0, size.cellSize / 2);
            visual.origin   = scaledSize.clone().subtract_xyz(scaledSize.x / 2, scaledSize.y / 2);
            visual.size     = scaledSize;
            visual.geometry = brushedGeom;

            /*
            // Find the initial width and height of the render texture before scaling.
            var cell : phoenix.Texture = Luxe.resources.texture('assets/images/cell.png');
            var baseWidth  = cell.width  * puzzle.columns();
            var baseHeight = cell.height * puzzle.rows();

            // Create a new render texture which all of the cell geometries will appear on.
            data.targetTexture = new RenderTexture({ id : 'rtt_brush', width : baseWidth, height : baseHeight });

            // Create a batcher, set it's viewport to the size of the puzzle, and set up events to change the renderers target.
            data.batcher = Luxe.renderer.create_batcher({ name : 'batcher_brush' });
            data.batcher.view.viewport = new Rectangle(0, 0, baseWidth, baseHeight);
            data.batcher.on(BatcherEventType.prerender , beforeRender.bind(_, data.targetTexture));
            data.batcher.on(BatcherEventType.postrender, afterRender);

            // Create brush and pencil geometries and add them to the batcher.
            data.brushedCells = [ for (row in 0...puzzle.rows()) [ for (col in 0...puzzle.columns()) Luxe.draw.texture({
                        x : col * cell.width,
                        y : row * cell.height,
                        color   : new Color().rgb(0x666666),
                        texture : Luxe.resources.texture('assets/images/cell.png'),
                        batcher : data.batcher
                    }) ] ];
			data.penciledCells = [ for (row in 0...puzzle.rows()) [ for (col in 0...puzzle.columns()) Luxe.draw.texture({
                        x : col * cell.width,
                        y : row * cell.height,
                        color   : new Color(0, 0, 0, 0),
                        texture : Luxe.resources.texture('assets/images/pencil.png'),
                        batcher : data.batcher
                    }) ] ];

            // Determine the scaled size of the puzzle display and cell size.
            var scaledSize : Vector = aspectRationFit(baseWidth, baseHeight, Luxe.screen.width * 0.6, Luxe.screen.height * 0.6);
            size.cellSize = scaledSize.x / puzzle.columns();

            visual.pos    = Luxe.screen.mid.add_xyz(0, size.cellSize / 2);
            visual.origin = scaledSize.clone().subtract_xyz(scaledSize.x / 2, scaledSize.y / 2);
            visual.size   = scaledSize;

            visual.geometry = Luxe.draw.texture({
                flipy : true,
                w : scaledSize.x,
                h : scaledSize.y,
                texture : data.targetTexture
            });
            */
        }
    }

    override public function onremoved()
    {
        entity.events.unlisten('cell.brushed');
        entity.events.unlisten('cell.penciled');
        entity.events.unlisten('cell.removed');
    }

    private function aspectRationFit(_srcWidth : Float, _srcHeight : Float, _maxWidth : Float, _maxHeight : Float) : Vector
    {
        var ratio = Math.min(_maxWidth / _srcWidth, _maxHeight / _srcHeight);
        return new Vector(_srcWidth * ratio, _srcHeight * ratio);
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
     *  Loop over the completed grid and set each cell in the display to the completed equivilent.
     */
    private function debug_setActiveToComplete()
    {
        var debugPuzzle : Puzzle = cast get('puzzle');
        var grid = debugPuzzle.completed.data;

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
