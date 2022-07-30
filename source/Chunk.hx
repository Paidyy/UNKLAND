import flixel.FlxCamera;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxRect;

class Chunk {
	public var blockCoords0:Map<String, Block>;
	public var blockCoords1:Map<String, Block>;
	public var blocksLayer1:FlxTypedGroup<Block>;
	public var blocksLayer0:FlxTypedGroup<Block>;

	public function new() {
		blockCoords0 = new Map();
		blockCoords1 = new Map();
		blocksLayer1 = new FlxTypedGroup<Block>();
		blocksLayer0 = new FlxTypedGroup<Block>();
    }

	public function setBlock(block:Block, layer:Int) {
		//TODO replace it with 3 dimensional coordinates?
		(layer == 0 ? blockCoords0 : blockCoords1).set(Point.string(block.worldX, block.worldY), block);
		(layer == 0 ? blocksLayer0 : blocksLayer1).add(block);
		block.updateLightSourceShit();
	}

	public function getBlock(worldX, worldY, layer) {
		return (layer == 0 ? blockCoords0 : blockCoords1).get(Point.string(worldX, worldY));
	}

	private static inline var ALPHABET = "abcdefghijklmnopqrstuvwxyz";
	public function sortLayers(layer:Int) {
		// thanks for this Geokureli
		(layer == 0 ? blocksLayer0 : blocksLayer1).members.sort((a, b) -> {
			var aStr = a.graphic.key.toLowerCase();
			var bStr = b.graphic.key.toLowerCase();

			var aInt = ALPHABET.indexOf(aStr.split("")[0]);
			var bInt = ALPHABET.indexOf(bStr.split("")[0]);

			if (aInt < bInt) {
				return -1;
			}
			else if (aInt > bInt) {
				return 1;
			}
			else {
				return 0;
			}
		});
	}
}

typedef ChunkMap = Map<Point, Chunk>;

class Point {
	public var x:Int = 0;
	public var y:Int = 0;

	public function new(X:Int = 0, Y:Int = 0) {
		x = X;
        y = Y;
	}

	public static function string(worldX:Int, worldY:Int) {
		return '$worldX,$worldY';
	}
}