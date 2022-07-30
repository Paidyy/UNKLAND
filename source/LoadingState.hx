import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxState;

class LoadingState extends FlxState {
    override public function create() {
        super.create();

		var loading = new FlxText(0, 0, 0, "Generating Terrain...", 30);
        loading.color = FlxColor.WHITE;
		loading.screenCenter();
        add(loading);

        var text = new FlxText(0, 0, 0, "", 20);
		text.font = "assets/fonts/vcr.ttf";
		text.text = Util.randomFileLine("assets/data/loadingTexts.txt");
        text.screenCenter(X);
        text.y = FlxG.height - text.height - 25;
        add(text);
        
		FlxG.switchState(new PlayState());
    }
}