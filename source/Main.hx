package;

import flixel.FlxG;
import flixel.FlxGame;
import flixel.system.FlxSplash;
import flixel.util.FlxColor;
import openfl.display.FPS;
import openfl.display.Sprite;

class Main extends Sprite {
	public function new() {
		super();

		Options.initialize();

		addChild(new FlxGame(0, 0, MainMenu, 1, Options.fps, Options.fps));
		addChild(new FPS(5, 5, FlxColor.WHITE));

		FlxG.fixedTimestep = false;
	}
}
