package data;

class Stats
{
    public var time : Float;
    public var faults : Int;

    public function new()
    {
        time = 0.0;
        faults = 0;
    }

    public function formattedTime() : String
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
