package ui;

import mint.render.luxe.Convert;

/** This canvas will automatically listen to relevant luxe events, when you call auto_listen()
    which is convenient for quickly testing things and throwing ideas around. To stop listening call auto_unlisten(). */
class AutoCanvas extends mint.Canvas
{
    public function auto_listen()
    {
        Luxe.on(luxe.Ev.render,     conv_render);
        Luxe.on(luxe.Ev.update,     conv_update);
        Luxe.on(luxe.Ev.mousewheel, conv_mousewheel);
        Luxe.on(luxe.Ev.mousedown,  conv_mousedown);
        Luxe.on(luxe.Ev.mouseup,    conv_mouseup);
        Luxe.on(luxe.Ev.mousemove,  conv_mousemove);
        Luxe.on(luxe.Ev.keyup,      conv_keyup);
        Luxe.on(luxe.Ev.keydown,    conv_keydown);
        Luxe.on(luxe.Ev.textinput,  conv_textinput);
            //make sure we clean up
        ondestroy.listen(auto_unlisten);
    }

    public function auto_unlisten()
    {
        Luxe.off(luxe.Ev.render,     conv_render);
        Luxe.off(luxe.Ev.update,     conv_update);
        Luxe.off(luxe.Ev.mousewheel, conv_mousewheel);
        Luxe.off(luxe.Ev.mousedown,  conv_mousedown);
        Luxe.off(luxe.Ev.mouseup,    conv_mouseup);
        Luxe.off(luxe.Ev.mousemove,  conv_mousemove);
        Luxe.off(luxe.Ev.keyup,      conv_keyup);
        Luxe.off(luxe.Ev.keydown,    conv_keydown);
        Luxe.off(luxe.Ev.textinput,  conv_textinput);
            //no longer try to clean up
        ondestroy.remove(auto_unlisten);
    }

    function conv_update(dt:Float)  update(dt);
    function conv_render(_)         render();
    function conv_mousewheel(e)     mousewheel(Convert.mouse_event(e, scale));
    function conv_mousedown(e)      mousedown(Convert.mouse_event(e, scale));
    function conv_mouseup(e)        mouseup(Convert.mouse_event(e, scale));
    function conv_mousemove(e)      mousemove(Convert.mouse_event(e, scale));
    function conv_keyup(e)          keyup(Convert.key_event(e));
    function conv_keydown(e)        keydown(Convert.key_event(e));
    function conv_textinput(e)      textinput(Convert.text_event(e));
}