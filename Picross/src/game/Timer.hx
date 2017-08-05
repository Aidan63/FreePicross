package game;

import luxe.Entity;

class Timer extends Entity
{
    public var time : Float;
    private var running : Bool;

    public function start()
    {
        time = 0;
        running = true;
    }

    public function stop()
    {
        running = false;
    }

    override public function update(_dt : Float)
    {
        if (!running) return;
        
        time += 1 * _dt;
    }

    public function getFormattedTime() : String
    {
        var minutesNum = Math.floor(time / 60);
        var secondsNum = Math.floor(time % 60);

        var minutes : String;
        var seconds : String;
        minutesNum < 10 ? minutes = '0' + Std.string(minutesNum) : minutes = Std.string(minutesNum);
        secondsNum < 10 ? seconds = '0' + Std.string(secondsNum) : seconds = Std.string(secondsNum);

        return minutes + ':' + seconds;
    }
}
