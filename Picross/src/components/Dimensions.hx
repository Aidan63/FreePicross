package components;

import luxe.Component;

class Dimensions extends Component
{
    /**
     *  The size of each cell.
     */
    public var cellSize : Float;

    /**
     *  The total width of the puzzle display.
     */
    //public var width : Float;

    /**
     *  The total height of the puzzle display.
     */
    //public var height : Float;

    override public function onadded()
    {
        cellSize = 0;
        //width = 0;
        //height = 0;
    }
}
