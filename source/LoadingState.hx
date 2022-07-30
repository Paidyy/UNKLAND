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

        #if html5
        var warning = new FlxText(0, 0, 0, "HTML VERSION IS EXPERIMENTAL, DESKTOP VERSION IS RECOMMENDED", 20);
		warning.color = FlxColor.RED;
		warning.screenCenter();
        warning.y = loading.y + loading.height + 25;
        add(warning);
        #end

        var text = new FlxText(0, 0, 0, "", 20);
		text.font = "assets/fonts/vcr.ttf";
		text.text = Util.randomFileLine("assets/data/loadingTexts.txt");
        text.screenCenter(X);
        text.y = FlxG.height - text.height - 25;
        add(text);
        
		FlxG.switchState(new PlayState());
    }
}