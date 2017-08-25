
import luxe.GameConfig;
import luxe.Input;
import luxe.Vector;
import luxe.States;

class Main extends luxe.Game
{
    private var gameState : States;

    override function config(_config : GameConfig)
    {
        _config.window.title = 'luxe game';
        _config.window.width = 1280;
        _config.window.height = 720;
        _config.window.fullscreen = false;

        return _config;
    }

    override function ready()
    {
        Luxe.camera.size = new Vector(1280, 720);
        Luxe.camera.size_mode = cover;

        gameState = new States({ name : 'game_state' });
        gameState.add(new states.game.GameState({ name : 'game' }));

        gameState.add(new states.designer.DesignerState({ name : 'designer' }));
        gameState.add(new states.designer.DesignerPause({ name : 'designer_pause' }));

        gameState.add(new states.ugc.MyPuzzles({ name : 'myPuzzles' }));
        gameState.add(new states.ugc.MyPuzzlesCreate({ name : 'myPuzzles_create' }));

        gameState.set('myPuzzles');
    }

    override function onkeyup(_event : KeyEvent)
    {
        if (_event.keycode == Key.escape)
        {
            Luxe.shutdown();
        }
    }
}
