import flixel.FlxG;
import openfl.Assets;
import Chunk.Point;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxSprite;
import flixel.group.FlxGroup;

using StringTools;

class Util {
	public static function isOnScreen(rect:Dynamic, camera:FlxCamera) {
		/*
		if (Std.isOfType(rect, Block)) {
			var sprite:Block = cast rect;
			return sprite.x <= camera.scroll.x + camera.width
				&& sprite.x + sprite.frameWidth >= camera.scroll.x
				&& sprite.y <= camera.scroll.y + camera.height
				&& sprite.y + sprite.frameHeight >= camera.scroll.y;
		}
		else
		*/
		if (Std.isOfType(rect, Point)) {
			return rect.x <= camera.scroll.x + camera.width
				&& rect.x + (World.BLOCKSIZE * World.CHUNKSIZE) >= camera.scroll.x
				&& rect.y <= camera.scroll.y + camera.height
				&& rect.y + (World.BLOCKSIZE * World.CHUNKSIZE) >= camera.scroll.y;
		}

		return rect.x <= camera.scroll.x + camera.width
			&& rect.x + rect.width >= camera.scroll.x
			&& rect.y <= camera.scroll.y + camera.height
			&& rect.y + rect.height >= camera.scroll.y;
	}

	public static function moveFromGroup(swag:FlxBasic, from:FlxTypedGroup<Dynamic>, to:FlxTypedGroup<Dynamic>) {
		if (!from.members.contains(swag))
			return;
		from.remove(swag);
		to.add(swag);
	}

	public static function curBrightnessWorldTime() {
		var _time = 0.0;
		if (PlayState.instance.world.curTime <= (1000 + World.dayDuration)) {
			_time = (PlayState.instance.world.curTime - 4000) / 1000;
			if (PlayState.instance.world.curTime < 4000) {
				_time = 0.0;
			}
		}
		else {
			_time = (1000 - (PlayState.instance.world.curTime - (1000 + World.dayDuration))) / 1000;
		}

		return _time;
	}

	public static function randomFileLine(path:String) {
		var splittedText = Assets.getText(path).trim().split("\n");
		return splittedText[FlxG.random.int(0, splittedText.length - 1)];
	}

	public static function getDiamondCoords(X:Int, Y:Int, height:Int = 3, returnCentered:Bool = true):Array<Array<Int>> {
		var finalCoords:Array<Array<Int>> = [];

		if (returnCentered) {
			X -= height;
			Y -= height - 1;
		}

		var begX = X;

		for (y in 0...height + 1) {
			var space = height;
			while (space > y && y != 0) {
				// Sys.print(" ");
				space--;
				X++;
			}
			// left
			for (x in 0...y) {
				// Sys.print("#");
				X++;
				finalCoords.push([X, Y]);
			}
			// right
			for (_x in 0...y - 1) {
				// Sys.print("#");
				X++;
				finalCoords.push([X, Y]);
			}
			if (y != 0) {
				// Sys.println("");
				X = begX;
				Y++;
			}
		}

		for (y in 1...height + 1) {
			var space = height;
			while (space > height - y && y != height) {
				// Sys.print(" ");
				space--;
				X++;
			}
			// left
			for (x in 0...(height) - y) {
				// Sys.print("#");
				X++;
				finalCoords.push([X, Y]);
			}
			// right
			for (_x in 0...(height - y) - 1) {
				// Sys.print("#");
				X++;
				finalCoords.push([X, Y]);
			}
			if (y != height) {
				// Sys.println("");
				X = begX;
				Y++;
			}
		}

		return finalCoords;
	}
}