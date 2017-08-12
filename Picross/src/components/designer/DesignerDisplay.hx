package components.designer;

import luxe.Component;
import luxe.Visual;
import luxe.Vector;
import luxe.Color;
import luxe.Rectangle;
import luxe.options.ComponentOptions;
import phoenix.geometry.QuadPackGeometry;
import phoenix.RenderTexture;
import phoenix.Batcher;
import components.Dimensions;
import data.IPuzzle;
import game.PuzzleState;

class DesignerDisplay extends Component
{
    private var visual : Visual;

    private var geom : QuadPackGeometry;

    private var quadUUIDs : Array<Array<Int>>;

    private var maxSize : Vector;

    /**
     *  The texture the brush and pencil quad packs will be drawn to.
     *  This texture will then be used for this components entity's texture.
     */
    private var targetTexture : RenderTexture;

    /**
     *  The batcher for the two quad pack geometries.
     */
    private var cellBatcher : Batcher;

    public function new(_options : DesignerDisplayOptions)
    {
        super(_options);

        maxSize = _options.boundary;
    }

    override public function onadded()
    {
        visual = cast entity;

        entity.events.listen('cell.brushed', onCellBrushed);
        entity.events.listen('cell.removed', onCellRemoved);

        if (has('grid') && has('dimensions'))
        {
            var grid : IPuzzle    = cast get('grid');
            var size : Dimensions = cast get('dimensions');

            // Get the actual width and height of this puzzle as well as the cell size.
            var baseWidth  = 128 * grid.columns();
            var baseHeight = 128 * grid.rows();
            var scaledSize : Vector = aspectRationFit(baseWidth, baseHeight, maxSize.x, maxSize.y);
            size.cellSize = scaledSize.x / grid.columns();

            // Creates the render texture and batcher for the quad pack geometries.
            targetTexture = new RenderTexture({ id : 'rtt_designerCells', width : Math.round(scaledSize.x), height : Math.round(scaledSize.y) });

            cellBatcher = Luxe.renderer.create_batcher({ name : 'designer_batcher' });
            cellBatcher.view.viewport = new Rectangle(0, 0, baseWidth, baseHeight);
            cellBatcher.on(BatcherEventType.prerender , beforeRender.bind(_, targetTexture));
            cellBatcher.on(BatcherEventType.postrender, afterRender);

            geom = new QuadPackGeometry({
                batcher : cellBatcher
            });

            quadUUIDs = [ for (row in 0...grid.rows()) [ for (col in 0...grid.columns()) geom.quad_add({
                        x : col * size.cellSize,
                        y : row * size.cellSize,
                        w : size.cellSize,
                        h : size.cellSize,
                        color : new Color(0, 0, 0, 0)
                    }) ] ];

            visual.size = scaledSize;
            targetTexture.filter_mag = targetTexture.filter_min = nearest;

            visual.geometry = Luxe.draw.texture({
                texture : targetTexture,
                flipy   : true
            });
        }
    }

    override public function onremoved()
    {
        entity.events.unlisten('cell.brushed');
        entity.events.unlisten('cell.removed');

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

    private function onCellBrushed(_position : data.events.CellPosition)
    {
        var uuid = quadUUIDs[_position.row][_position.column];
        geom.quad_color(uuid, PuzzleState.color.designerColor.clone());
    }

    private function onCellRemoved(_position : data.events.CellPosition)
    {
        var uuid = quadUUIDs[_position.row][_position.column];
        geom.quad_alpha(uuid, 0);
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
}

typedef DesignerDisplayOptions = {
    > ComponentOptions,
    var boundary : Vector;
}
