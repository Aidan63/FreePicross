package states;

import luxe.States;
import luxe.Input;
import mint.focus.Focus;
import mint.layout.margins.Margins;
import mint.render.luxe.LuxeMintRender;
import ui.AutoCanvas;
import utils.Clipboard;

class DesignerPuzzleList extends State
{
    // Mint stuff
    private var focus     : Focus;
    private var layout    : Margins;
    private var canvas    : AutoCanvas;
    private var rendering : LuxeMintRender;

    //
    private var inputURL : mint.TextEdit;
    private var inputFile : mint.TextEdit;
    private var bttnDialog : mint.Button;
    private var bttnCreate : mint.Button;

    private var errorPopup : mint.Panel; 

    override public function onenter<T>(_data : T)
    {
        // Setup mint
        rendering = new LuxeMintRender();
        layout    = new Margins();
        canvas    = new AutoCanvas({
            name : 'canvas',
            rendering : rendering,
            x : 0,
            y : 0,
            w : Luxe.screen.width  / Luxe.screen.device_pixel_ratio,
            h : Luxe.screen.height / Luxe.screen.device_pixel_ratio,
        });

        focus = new Focus(canvas);
        canvas.auto_listen();

        var panelBkg = new mint.Panel({
            parent : canvas,
            name : 'panel_bkg',
            x : 416, y : 144, w : 416, h : 432
        });

        new mint.Label({
            name : 'title_label',
            parent : panelBkg,
            text_size : 30,
            x : 16, y : 16, w : 384, h : 64,
            text : 'New Puzzle',
            align : center,
            align_vertical : center
        });

        new mint.Label({
            name : 'label_url',
            parent : panelBkg,
            text_size : 16,
            x : 16, y : 96, w : 384, h : 32,
            text : 'Load finished image from URL',
            align : left,
            align_vertical : center
        });

        inputURL = new mint.TextEdit({
            name : 'input_url',
            parent : panelBkg,
            text_size : 16,
            text : '',
            x : 16, y : 144, w : 384, h : 64
        });

        new mint.Label({
            name : 'label_file',
            parent : panelBkg,
            text_size : 16,
            x : 16, y : 224, w : 384, h : 32,
            text : 'Load finished image from file',
            align : left,
            align_vertical : center
        });

        inputFile = new mint.TextEdit({
            name : 'input_file',
            parent : panelBkg,
            text_size : 16,
            text : '',
            x : 16, y : 272, w : 304, h : 64
        });

        bttnDialog = new mint.Button({
            name : 'button_fileDialog',
            parent : panelBkg,
            x : 336, y : 272, w : 64, h : 64,
            text : '...',
            align : center,
            align_vertical : center,
            onclick : onOpenFileDialog
        });

        bttnCreate = new mint.Button({
            name : 'button_new',
            parent : panelBkg,
            x : 16, y : 352, w : 384, h : 64,
            text : 'Create',
            align : center,
            align_vertical : center,
            onclick : onCreatePuzzle
        });
    }

    override public function onleave<T>(_data : T)
    {
        if (errorPopup != null) luxe.tween.Actuate.stop(errorPopup);

        focus.destroy();
        canvas.destroy();
    }

    override public function update(_dt : Float)
    {
        // Update the text inputs with the clipboard on sys targets.
        if (Luxe.input.keydown(Key.lctrl) && Luxe.input.keypressed(Key.key_v))
        {
            if (inputURL.isfocused)
            {
                inputURL.text = Clipboard.get();
            }

            if (inputFile.isfocused)
            {
                inputURL.text = Clipboard.get();
            }
        }
    }

    /**
     *  Open a file dialog and set the file text input to the resulting path.
     *  @param _ - 
     *  @param _ - 
     */
    private function onOpenFileDialog(_, _)
    {
        #if sys
        var result = dialogs.Dialogs.open('Load image', [
            { ext : 'jpeg', desc : 'JPEG image' },
            { ext : 'jpg' , desc : 'JPEG image' },
            { ext : 'png' , desc : 'PNG image' },
        ]);

        if (result != null) inputFile.text = result;
        #end
    }

    private function onCreatePuzzle(_, _)
    {
        if (inputFile.text == '' && inputURL.text == '')
        {
            return;
        }

        if (inputURL.text != '')
        {
            var resLoader = new utils.Resources();
            resLoader.onLoaded = onImageLoaded;
            resLoader.onError = createError;

            resLoader.loadFromURL(inputURL.text, 'testImage');
        }
        else
        {
            var resLoader = new utils.Resources();
            resLoader.onLoaded = onImageLoaded;
            resLoader.onError = createError;

            resLoader.loadFromFile(inputFile.text, 'testImage');
        }
    }

    private function onImageLoaded()
    {
        var tex = Luxe.resources.texture('testImage');
        if (tex.width > 32 || tex.height > 32)
        {
            machine.set('designer', new data.states.DesignerTextureSize(32, 32, null));
        }
        else
        {
            machine.set('designer', new data.states.DesignerTextureSize(tex.width, tex.height, tex));
        }
    }

    private function createError(_error : String)
    {
        if (errorPopup != null) errorPopup.destroy();

        errorPopup = new mint.Panel({
            parent : canvas,
            name : 'errorBkg',
            x : 416, y : -64, w : 416, h : 64,
            options : {
                color : new luxe.Color().rgb(0xff4747)
            }
        });
        new mint.Label({
            parent : errorPopup,
            name : 'label',
            text_size : 12,
            text : _error,
            x : 0, y : 0, w : 416, h : 64,
            align : center,
            align_vertical : center
        });

        luxe.tween.Actuate.tween(errorPopup, 0.25, { y : 32 }).ease(luxe.tween.easing.Quad.easeOut).onComplete(function() {
            luxe.tween.Actuate.tween(errorPopup, 0.25, { y : -64 }).ease(luxe.tween.easing.Quad.easeIn).delay(5).onComplete(function() {
                errorPopup.destroy();
            });
        });
    }
}
