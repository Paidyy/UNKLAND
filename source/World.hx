import Chunk.Point;
import Chunk.ChunkMap;
import flixel.FlxG;
import flixel.addons.util.FlxSimplex;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxRandom;
import flixel.math.FlxRect;

class World {
	public var seed = 0;
	public var scale = 0.001;
	public var persistence = 0.25;
	public var octaves = 4;

	public static inline var BLOCKSIZE = 46;
	public static inline var CHUNKSIZE = 24;

	//public var blocksLayer1:FlxTypedGroup<Block> = new FlxTypedGroup<Block>();
	//public var blocksLayer0:FlxTypedGroup<Block> = new FlxTypedGroup<Block>();
	public var chunks:ChunkMap = new ChunkMap();
	public var chunkPoints:Map<String, Point> = new Map<String, Point>();

	/**
	 * Time from 0 to `dayDuration`
	 * Duration of going to night or day is 1000
	 */
	public var curTime(default, set):Float = 4700;

	/**
	 * day like the day of the month not day ok?
	 */
	public static inline var dayDuration = 9000;

	/**
		Couldve used FlxPoint but nah
	**/
	public var worldSpawn:Array<Float>;

    public function new(?seed:Null<Int> = null) {
        this.seed = seed == null ? generateSeed() : seed;
		worldSpawn = null;
    }

	public function update(elapsed:Float) {
		curTime += elapsed * 16;
		FlxG.watch.addQuick("worldTime", curTime);
	}

	public static function generateSeed():Int {
		return new FlxRandom().int(0, 10000);
	}

	public function getChunk(worldX:Int, worldY:Int):Chunk {
		return chunks.get(chunkPoints.get(Point.string(worldX, worldY)));
	}

	public function getBlock(worldX:Int, worldY:Int, layer:Int):Block {
		return getChunk(Std.int(worldX / World.CHUNKSIZE), Std.int(worldY / World.CHUNKSIZE)).getBlock(worldX, worldY, layer);
	}

	public function generateChunk(worldX:Int = 0, worldY:Int = 0) {
		var x = worldX * (BLOCKSIZE * CHUNKSIZE);
		var y = worldY * (BLOCKSIZE * CHUNKSIZE);

		if (seed == 0)
			seed = generateSeed();

		var chunk = new Chunk();

		for (xi in 0...CHUNKSIZE) {
			for (yi in 0...CHUNKSIZE) {
				var X = x + (BLOCKSIZE * xi);
				var Y = y + (BLOCKSIZE * yi);

				var noise = FlxSimplex.simplexTiles(X, Y, BLOCKSIZE * CHUNKSIZE, BLOCKSIZE * CHUNKSIZE, seed, scale, persistence, octaves);
				noise = (noise + 1) / 2;

				var random = FlxG.random.int(0, 200);

				if (noise <= 0.43) {
					var block = new Block(X, Y, WATER);
					chunk.setBlock(block, 0);

					if (random == 1) {
						var tree = new Block(X, Y, COTTONPLANT);
						chunk.setBlock(tree, 1);
					}
				}
				else if (noise <= 0.52) {
					var block = new Block(X, Y, SAND);
					chunk.setBlock(block, 0);
					if (worldSpawn == null)
						worldSpawn = [X, Y];
				}
				else if (noise <= 0.65) {
					//things that you should touch irl!
					var block = new Block(X, Y, GRASS);
					chunk.setBlock(block, 0);
					
					if (random == 1) {
						var tree = new Block(X, Y, TREE);
						chunk.setBlock(tree, 1);
					}
					else if (random >= 195) {
						var flower = new Block(X, Y, POPPY);
						chunk.setBlock(flower, 1);
					}
					else if (random >= 190) {
						var flower = new Block(X, Y, DANDELION);
						chunk.setBlock(flower, 1);
					}
					else if (random >= 70) {
						var grass = new Block(X, Y, TOUCHIT);
						chunk.setBlock(grass, 1);
					}
				}
				/*
					else if (noise <= 0.75) {
						var block = new Block(X, Y, FOREST);
						block.setWorldPosition(Std.int(X / BLOCKSIZE), Std.int(Y / BLOCKSIZE));
						setBlock(block, 0);
					}
				 */
				else if (noise <= 1) {
					var block = new Block(X, Y, STONE);
					block.immovable = true;
					chunk.setBlock(block, 1);

					var underBlock = new Block(X, Y, GRASS);
					chunk.setBlock(underBlock, 0);
				}
			}
		}
		chunk.sortLayers(0);
		chunk.sortLayers(1);
		var chunkPoint = new Point(x, y);
		chunks.set(chunkPoint, chunk);
		chunkPoints.set(Point.string(worldX, worldY), chunkPoint);
	}

	function set_curTime(value:Float):Float {
		curTime = value;
		if (value > (2000 + dayDuration)) {
			curTime = 0;
		}
		return curTime;
	}
}