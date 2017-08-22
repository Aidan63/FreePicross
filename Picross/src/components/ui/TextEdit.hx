package components.ui;

import luxe.Vector;
import luxe.Component;
import luxe.Input;
import luxe.Text;
import luxe.Log.*;

using luxe.utils.unifill.Unifill;

typedef TextEditOptions = {
    ?name:String,
        //A regex string for what to include in the text control
        //i.e if you want numbers only, set this to numbers only regex
    ?filter:EReg
}

class TextEdit extends Component {

    var text : Text;
    var edit : String = '';
    var index : Int = 0;

    var lp0:Vector;
    var lp1:Vector;
    var blink = false;
    var next_blink:Float = 0.0;

    public var filter:EReg;

    public function new( ?_options:TextEditOptions ) {

        _options = def(_options, {});
        var _name = def(_options.name,'text_edit');
        super({ name:_name });

        lp0 = new Vector();
        lp1 = new Vector();

        if(_options.filter != null) filter = _options.filter;

    }

    override function onadded() {
        text = cast entity;
        edit = text.text;
        text.transform.world.auto_decompose = true;
        text.transform.world.decompose();
        index = edit.uLength();
        refresh(edit);
    }

    override function ontextinput( event:TextEvent ) {

        if(filter != null) {
            if(!filter.match(event.text)) {
                return;
            }
        }

        var b = before(index);
        var a = after(index);
        index += event.text.uLength();
        refresh( b + event.text + a );
    } //ontextinput

    override function onkeydown( event:KeyEvent ) {
        switch(event.keycode) {
            case Key.backspace:
                move(-1);
                cut(index, 1);
            case Key.delete:
                cut(index, 1);
            case Key.left: move(-1);
            case Key.right: move(1);
            case Key.enter:
        }
    } //onkeydown

    inline function refresh( str:String ) {
        text.text = edit = str;
        update_cur();
        return edit;
    } //refresh

    function move(amount:Int = -1) {
        index += amount;
        index = Std.int(luxe.utils.Maths.clamp(index, 0, edit.uLength()));
        // trace('index $index / ${edit.uLength()}');
        // trace(before(index) + '|' + after(index));
        update_cur();
    }

    inline function cut( start:Int = 0, count:Int = 1 ) {
        var a = after(start);
        return refresh( before(start) + a.uSubstr(count, a.uLength()) );
    }

    inline function after( cur:Int = 0 ) return edit.uSubstr(cur, edit.length);
    inline function before( cur:Int = 0 ) return edit.uSubstr(0, cur);

    function update_cur() {

        var _t = before(index);
        var _tw = text.font.width_of(edit,text.point_size, text.letter_spacing);
        var _twh = _tw/2.0;
        var _w = text.font.width_of(_t, text.point_size, text.letter_spacing);

        var _th = text.font.height_of(_t, text.point_size);
        var _thh = _th/2.0;

        var _x = _w;
        var _y = 0.0;

        _x -= switch(text.align) {
            case center: _twh;
            case right: _tw;
            case _: 0.0;
        }

        _y -= switch(text.align_vertical) {
            case center: _thh;
            case bottom: _th;
            case _: 0.0;
        }

        _y += _th * 0.2;

        lp0.x = text.transform.world.pos.x + _x;
        lp1.x = text.transform.world.pos.x + _x;
        lp0.y = text.transform.world.pos.y + _y;
        lp1.y = text.transform.world.pos.y + _y + text.point_size;
    }

    override function update( dt:Float ) {

        if(Luxe.time > next_blink) {
            blink = !blink;
            next_blink = Luxe.time + 0.7;
        }

        if(!blink) {
            Luxe.draw.line({
                p0: lp0, p1: lp1, immediate:true,
                depth : 10
            });
        }

    } //update

} //TextEdit