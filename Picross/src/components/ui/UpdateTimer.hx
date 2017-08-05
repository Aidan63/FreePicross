package components.ui;

import luxe.Component;
import luxe.Text;
import game.PuzzleState;

class UpdateTimer extends Component
{
    var text : Text;

    override public function onadded()
    {
        text = cast entity;
    }

    override public function update(_dt : Float)
    {
        text.text = PuzzleState.timer.getFormattedTime();
    }
}
