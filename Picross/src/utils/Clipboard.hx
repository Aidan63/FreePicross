package utils;

class Clipboard
{
    public static inline function get() : String
    {
        #if sys
            return sdl.SDL.getClipboardText();
        #else
            return '';
        #end
    }
}