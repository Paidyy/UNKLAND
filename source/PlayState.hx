package;

import flixel.FlxSubState;
import flixel.text.FlxText;
import Chunk.ChunkMap;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import haxe.display.Display.Package;

class PlayState extends FlxState {
	public static var instance:PlayState;
	
	public var player:Player;
	public var world:World;

	@:allow(PlayerCursor, Zombie)
	var _renderedBlocks0:FlxTypedGroup<Block>;
	@:allow(PlayerCursor, Zombie)
	var _renderedBlocks1:FlxTypedGroup<Block>;

	public var swagCam:FlxCamera;
	public var hudCam:FlxCamera;

	public var worldBarrier:WorldBarrier;

	public var blockPlayer:Block;
	public var blockMouse:Block;

	public var playerCursor:PlayerCursor;
	
	public var gui:Gui;

	public var groundItems:FlxTypedGroup<Item>;
	//public var slotItems:FlxTypedGroup<Item>;

	public var entities:FlxTypedGroup<Dynamic>;

	public var openedSubstate:Bool = false;

	public function new() {
		super();
		instance = this;

		//if (LightShader.instance == null)
			//new LightShader();
	}

	override public function openSubState(SubState:FlxSubState):Void {
		super.openSubState(SubState);

		openedSubstate = true;
	}

	override public function closeSubState():Void {
		super.closeSubState();

		openedSubstate = false;
	}

	public function spawnEntity(entity:Dynamic) {
		entities.add(entity);
	}
	
	override public function create() {
		persistentUpdate = true;

		swagCam = new FlxCamera();
		hudCam = new FlxCamera();
		hudCam.bgColor.alpha = 0;
		
		//i guess you can't do that? weird
		//FlxG.cameras.reset(FlxG.camera);
		FlxG.cameras.reset(swagCam);
		FlxG.cameras.add(hudCam, false);
		FlxG.cameras.setDefaultDrawTarget(swagCam, true);

		_renderedBlocks0 = new FlxTypedGroup<Block>();
		_renderedBlocks1 = new FlxTypedGroup<Block>();
		world = new World();
		for (x in 0...8) {
			for (y in 0...8) {
				world.generateChunk(x, y);
			}
		}

		player = new Player(world.worldSpawn[0], world.worldSpawn[1]);
		camera.follow(player);
		
		add(_renderedBlocks0);
		add(_renderedBlocks1);
		add(groundItems = new FlxTypedGroup<Item>());
		add(player);
		add(entities = new FlxTypedGroup());
		
		FlxG.worldBounds.set(0, 0, 8 * (World.BLOCKSIZE * World.CHUNKSIZE), 8 * (World.BLOCKSIZE * World.CHUNKSIZE));
		camera.setScrollBounds(0, 8 * (World.BLOCKSIZE * World.CHUNKSIZE), 0, 8 * (World.BLOCKSIZE * World.CHUNKSIZE));
		add(worldBarrier = new WorldBarrier());

		playerCursor = new PlayerCursor();
		playerCursor.cursorBlock.alpha = 0.3;
		add(playerCursor);
		add(playerCursor.breakStage);
		add(playerCursor.cursorBlock);
		add(playerCursor.mouseHitbox);

		//HUD
		playerCursor.pieDial.camera = hudCam;
		add(playerCursor.pieDial);

		var vignete = new FlxSprite().loadGraphic("assets/images/vignete.png");
		vignete.camera = hudCam;
		vignete.alpha = 0.3;
		add(vignete);

		gui = new Gui();
		gui.camera = hudCam;
		add(gui);

		renderChunks();
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		//LightShader.update();

		world.update(elapsed);

		if (!openedSubstate)
			controls();

		FlxG.collide(player, worldBarrier);
		FlxG.collide(player, _renderedBlocks1);

		FlxG.watch.addQuick("worldX", player.worldX);
		FlxG.watch.addQuick("worldY", player.worldY);
		FlxG.watch.addQuick("chunkX", player.chunkX);
		FlxG.watch.addQuick("chunkY", player.chunkY);
	}
	
	public function renderChunks() {
		blockMouse = null;
		blockPlayer = null;
		
		_renderedBlocks0.clear();
		_renderedBlocks1.clear();
		for (chunkLoc => chunk in world.chunks) {
			if (Util.isOnScreen(chunkLoc, camera)) {
				for (layer in 0...2) {
					(layer == 0 ? chunk.blocksLayer0 : chunk.blocksLayer1).forEach(block -> {
						if (block == null || !block.exists) {
							(layer == 0 ? chunk.blocksLayer0 : chunk.blocksLayer1).remove(block);
						} 
						else {
							if (!Options.accurateChunkLoading || Util.isOnScreen(block, camera)) {
								(layer == 0 ? _renderedBlocks0 : _renderedBlocks1).add(block);
								block.updateLightSourceShit(true);

								if (layer == 0
									&& block.worldX == Std.int(player.getMidpoint().x / World.BLOCKSIZE)
									&& block.worldY == Std.int(player.getMidpoint().y / World.BLOCKSIZE))
									blockPlayer = block;
								else if (layer == 1 && block.worldX == playerCursor.mouseBlockX && block.worldY == playerCursor.mouseBlockY)
									blockMouse = block;
							}
						}
					});
				}
			}
		}
	}

	public function controls() {
		if (FlxG.keys.justPressed.ESCAPE)
			openSubState(new PauseMenu());

		#if debug
		if (FlxG.keys.pressed.CONTROL) {
			if (FlxG.keys.justPressed.PLUS)
				camera.zoom += 0.05;
			if (FlxG.keys.justPressed.MINUS)
				camera.zoom -= 0.05;
		}
		else {
			if (FlxG.keys.pressed.PLUS)
				world.curTime += 5;
			if (FlxG.keys.pressed.MINUS)
				world.curTime -= 5;
		}


		if (FlxG.keys.justPressed.E)
			trace(player.inventory);

		if (FlxG.keys.justPressed.Z) {
			add(new Zombie());
		}
		#end

		if (FlxG.keys.justPressed.Q) {
			player.removeItem(player.curItem);
		}

		var angle:Float = 0;

		var up = FlxG.keys.anyPressed([UP, W]);
		var down = FlxG.keys.anyPressed([DOWN, S]);
		var left = FlxG.keys.anyPressed([LEFT, A]);
		var right = FlxG.keys.anyPressed([RIGHT, D]);

		if (up || down || left || right) {
			renderChunks();
			player.animation.play("walk");
			if (up) {
				//player.animation.play("UP");
				angle = -90;
				if (left)
					angle -= 45;
				else if (right)
					angle += 45;
			}
			else if (down) {
				//player.animation.play("DOWN");
				angle = 90;
				if (left)
					angle += 45;
				else if (right)
					angle -= 45;
			}
			else if (left) {
				//player.animation.play("LEFT");
				angle = 180;
			}
			else if (right) {
				//player.animation.play("RIGHT");
				angle = 0;
			}

			player.velocity.set((250 * (FlxG.keys.pressed.CONTROL ? 1.3 : 1.0)) * (blockPlayer.type == WATER ? 0.5 : 1), 0);
			player.velocity.rotate(FlxPoint.weak(0, 0), angle);
			player.angle = angle - 90;
		}
		else {
			player.velocity.set(0, 0);
			player.animation.play("idle");
		}
	}
}
