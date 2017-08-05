package components.ui;

import luxe.Component;
import luxe.Visual;

class Label extends Component
{
    /**
     *  This components entity cast to a visual type.
     */
    private var visual : Visual;

    override public function onadded()
    {
        visual = cast entity;
    }

    override public function onremoved()
    {
        //
    }
}
