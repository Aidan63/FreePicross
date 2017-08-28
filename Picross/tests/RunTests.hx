
import utest.Runner;
import utest.ui.Report;

class RunTests extends luxe.Game
{
    override function config(_config : luxe.GameConfig)
    {
        return _config;
    }

    override function ready()
    {
        // Run tests.
        var runner = new Runner();
        runner.addCase(new cases.TestEntityHelper());
        runner.addCase(new cases.TestPuzzleHelper());

        Report.create(runner);
        runner.run();

        Luxe.shutdown();
    }
}
