package components;

import luxe.Component;
import luxe.Rectangle;
import luxe.Vector;
import luxe.Color;
import phoenix.RenderTexture;
import phoenix.Batcher;

import components.Dimensions;
import components.Puzzle;
import data.PuzzleDisplay;
import data.IPuzzle;
import game.PuzzleState;

class Display extends Component
{
    public var data : PuzzleDisplay;

    override public function onadded()
    {
        // Connect entity events
        entity.events.listen('cell.brushed' , onCellBrushed);
        entity.events.listen('cell.penciled', onCellPenciled);
        entity.events.listen('cell.removed' , onCellRemoved);
        entity.events.listen('cell.clean'   , onCellCleaned);

        if (has('dimensions') && has('puzzle'))
        {
            var size   : Dimensions = cast get('dimensions');
            var puzzle : IPuzzle    = cast get('puzzle');

            // Will hold all information on the puzzle display.
            data = new PuzzleDisplay();

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

            // Create a visual class to hold the scaled geometry with the render texture.
            data.display = cast entity;

            pos    = Luxe.screen.mid.add_xyz(0, size.cellSize / 2);
            origin = scaledSize.clone().subtract_xyz(scaledSize.x / 2, scaledSize.y / 2);
            data.display.size = scaledSize;

            data.display.geometry = Luxe.draw.texture({
                flipy : true,
                w : scaledSize.x,
                h : scaledSize.y,
                texture : data.targetTexture
            });
        }
    }

    override public function onremoved()
    {
        entity.events.unlisten('cell.brushed');
        entity.events.unlisten('cell.penciled');
        entity.events.unlisten('cell.removed');

        for (row in data.brushedCells)
        {
            for (geom in row)
            {
                geom.drop();
            }
        }

        for (row in data.penciledCells)
        {
            for (geom in row)
            {
                geom.drop();
            }
        }

        data.batcher.destroy();
        data.targetTexture.destroy();
        data.display.geometry.drop();
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
     *  Changes the luxe renderer's target back to default after the cell batcher has been rendered.
     *  
     *  @param _batcher The batcher which has just been rendered.
     */
    private function afterRender(_batcher : Batcher)
    {
        Luxe.renderer.target = null;
    }

    // Entity event functions

    private function onCellBrushed(_position : data.events.CellPosition)
    {
        data.brushedCells [_position.row][_position.column].color = PuzzleState.color.getLuxeColor();
        data.penciledCells[_position.row][_position.column].color.a = 0;
    }

    private function onCellPenciled(_position : data.events.CellPosition)
    {
        data.penciledCells[_position.row][_position.column].color = PuzzleState.color.getLuxeColor();
    }

    private function onCellRemoved(_position : data.events.CellPosition)
    {
        data.brushedCells [_position.row][_position.column].color.set(1, 1, 1, 0);
        data.penciledCells[_position.row][_position.column].color.set(1, 1, 1, 0);
    }

    private function onCellCleaned(_position : data.events.CellPosition)
    {
        data.brushedCells [_position.row][_position.column].color.rgb(0x666666);
        data.penciledCells[_position.row][_position.column].color.set(1, 1, 1, 0);
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
