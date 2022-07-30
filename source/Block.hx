import Item.StackType;
import flixel.FlxG;
import flixel.FlxSprite;

class Block extends WorldObject {
	public var type:StackType = WATER;
	public var breakSpeed:Float = 1;
	public var swagWiggle:WiggleEffect = new WiggleEffect();

	public var isLightSource:Bool = false;
	public var lightLevel:Float = 0.0;
	public var lightSource:Block;
    
	public function new(X:Float = 0, Y:Float = 0, type:StackType = WATER) {
		super(X, Y);

		this.type = type;

		var randomAngle = false;

		switch (type) {
			case WATER:
				//loadGraphic("assets/images/blocks/water.png");
				loadGraphic("assets/images/blocks/water-animated.png", true, World.BLOCKSIZE, World.BLOCKSIZE);
				animation.add("idle", [0,1], 2, true);
				animation.play("idle");
			case SAND:
				loadGraphic("assets/images/blocks/sand.png");
				randomAngle = true;
			case GRASS:
				loadGraphic("assets/images/blocks/grass.png");
				randomAngle = true;
			case STONE:
				loadGraphic("assets/images/blocks/stone.png");
				randomAngle = true;
				breakSpeed = 0.05;
			case TORCH:
				loadGraphic("assets/images/blocks/torch.png");

				isLightSource = true;
				lightLevel = 0.8;

				allowCollisions = NONE;
				breakSpeed = 8;
			case TREE:
				loadGraphic("assets/images/blocks/tree.png");
				
				width = 46;
				height = 46;
				offset.set(World.BLOCKSIZE * 2, World.BLOCKSIZE * 4);
				//shader = swagWiggle.shader;

				breakSpeed = 0.15;
			case TOUCHIT:
				loadGraphic("assets/images/blocks/actualGrass.png");

				allowCollisions = NONE;
				breakSpeed = 6;
			case WOOD:
				loadGraphic("assets/images/blocks/wood.png");

				breakSpeed = 0.25;
			case WORKBENCH:
				loadGraphic("assets/images/blocks/workbench.png");

				breakSpeed = 0.45;
			case WOODPLANK:
				loadGraphic("assets/images/blocks/woodPlank.png");
			case STICK:
				loadGraphic("assets/images/items/stick.png");
			case COTTONPLANT:
				loadGraphic("assets/images/blocks/cottonPlant.png");

				allowCollisions = NONE;
				breakSpeed = 2;
			case ROPE:
				loadGraphic("assets/images/items/rope.png");

				allowCollisions = NONE;
				breakSpeed = 8;
			case POPPY:
				loadGraphic("assets/images/blocks/poppy.png");

				allowCollisions = NONE;
				breakSpeed = 8;
			case DANDELION:
				loadGraphic("assets/images/blocks/dandelion.png");

				allowCollisions = NONE;
				breakSpeed = 8;
			default:
		}

		if (randomAngle)
			angle += 90 * FlxG.random.int(0, 3);

		immovable = true;

		//shader = LightShader.instance;
		setBrightness(Util.curBrightnessWorldTime());
	}

	override public function update(elapsed) {
		super.update(elapsed);

		//updateLightSourceShit();
		
		setBrightness(Util.curBrightnessWorldTime());
		//swagWiggle.update(elapsed);
	}

	override public function destroy() {

		super.destroy();
	}

	public function updateLightSourceShit(onlyThis:Bool = false) {
		if (!isLightSource && (lightSource == null || !lightSource.exists))
			lightLevel = 0;

		if (isLightSource && !onlyThis) {
			for (coord in Util.getDiamondCoords(worldX, worldY, 8)) {
				if (PlayState.instance.world.getBlock(coord[0], coord[1], 0) != null)
					PlayState.instance.world.getBlock(coord[0], coord[1], 0).setCompareLight(lightLevel - 0.6, this);
				if (PlayState.instance.world.getBlock(coord[0], coord[1], 1) != null)
					PlayState.instance.world.getBlock(coord[0], coord[1], 1).setCompareLight(lightLevel - 0.65, this);
			}
			for (coord in Util.getDiamondCoords(worldX, worldY, 7)) {
				if (PlayState.instance.world.getBlock(coord[0], coord[1], 0) != null)
					PlayState.instance.world.getBlock(coord[0], coord[1], 0).setCompareLight(lightLevel - 0.4, this);
				if (PlayState.instance.world.getBlock(coord[0], coord[1], 1) != null)
					PlayState.instance.world.getBlock(coord[0], coord[1], 1).setCompareLight(lightLevel - 0.45, this);
			}
			for (coord in Util.getDiamondCoords(worldX, worldY, 6)) {
				if (PlayState.instance.world.getBlock(coord[0], coord[1], 0) != null)
					PlayState.instance.world.getBlock(coord[0], coord[1], 0).setCompareLight(lightLevel - 0.3, this);
				if (PlayState.instance.world.getBlock(coord[0], coord[1], 1) != null)
					PlayState.instance.world.getBlock(coord[0], coord[1], 1).setCompareLight(lightLevel - 0.35, this);
			}
			for (coord in Util.getDiamondCoords(worldX, worldY, 5)) {
				if (PlayState.instance.world.getBlock(coord[0], coord[1], 0) != null)
					PlayState.instance.world.getBlock(coord[0], coord[1], 0).setCompareLight(lightLevel - 0.2, this);
				if (PlayState.instance.world.getBlock(coord[0], coord[1], 1) != null)
					PlayState.instance.world.getBlock(coord[0], coord[1], 1).setCompareLight(lightLevel - 0.25, this);
			}
			for (coord in Util.getDiamondCoords(worldX, worldY, 4)) {
				if (PlayState.instance.world.getBlock(coord[0], coord[1], 0) != null)
					PlayState.instance.world.getBlock(coord[0], coord[1], 0).setCompareLight(lightLevel - 0.1, this);
				if (PlayState.instance.world.getBlock(coord[0], coord[1], 1) != null)
					PlayState.instance.world.getBlock(coord[0], coord[1], 1).setCompareLight(lightLevel - 0.15, this);
			}
			PlayState.instance.world.getBlock(worldX, worldY, 0).setCompareLight(lightLevel - 0.1, this);
		}
	}

	public function setCompareLight(value:Float, ?parentLight:Block = null) {
		if (parentLight != null)
			lightSource = parentLight;

		if (value >= lightLevel)
			lightLevel = value;
	}

	override function set_x(x:Float) {
		return this.x = x;
	}

	override function set_y(y:Float) {
		return this.y = y;
	}

	public function setBrightness(value:Float) {
		value += lightLevel;

		if (value > 1.0)
			value = 1.0;

		if (value < 0.1)
			value = 0.1;

		if (value <= 0.1 && FlxG.random.bool(0.001)) {
			PlayState.instance.spawnEntity(new Zombie(x, y));
		}

		colorTransform.redMultiplier = value;
		colorTransform.greenMultiplier = value;
		colorTransform.blueMultiplier = value;
	}
}