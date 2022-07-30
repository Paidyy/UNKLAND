import flixel.FlxObject;
import flixel.math.FlxPoint;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxPieDial;
import flixel.math.FlxMath;
import flixel.util.FlxColor;

class PlayerCursor extends FlxBasic {
    public var cursorBlock:FlxSprite;

    public var lastMouseBlockX:Int = 0;
    public var lastMouseBlockY:Int = 0;
    public var mouseBlockX:Int = 0;
	public var mouseBlockY:Int = 0;

	public var pieDial:FlxPieDial;

	public var breakStage:FlxSprite;

	public var mouseHitbox:FlxSprite;
    
    public function new() {
        super();
        
		cursorBlock = new FlxSprite().loadGraphic("assets/images/cursor-block.png");

		pieDial = new FlxPieDial(0, 0, 25, FlxColor.WHITE, 36, FlxPieDialShape.CIRCLE, true, 12, blockBreak);
		pieDial.amount = 0.0;
		pieDial.replaceColor(FlxColor.BLACK, FlxColor.TRANSPARENT);
		pieDial.antialiasing = true;

		mouseHitbox = new FlxSprite();
		mouseHitbox.makeGraphic(6, 6, FlxColor.TRANSPARENT);

		breakStage = new FlxSprite();
		breakStage.loadGraphic("assets/images/griefStages.png", true, 46, 46);
		breakStage.animation.add('0', [0]);
		breakStage.animation.add('1', [1]);
		breakStage.animation.add('2', [2]);
		breakStage.animation.add('3', [3]);
		breakStage.animation.add('4', [4]);
		breakStage.animation.play("0");
    }

	public function blockBreak() {
		var groundItem = new Item(PlayState.instance.blockMouse.type);
		groundItem.onGround = true;
		switch (PlayState.instance.blockMouse.type) {
			case TREE:
				groundItem.amount = 3;

				var apple = new Item(APPLE);
				apple.onGround = true;
				apple.setPosition(PlayState.instance.blockMouse.x + 5, PlayState.instance.blockMouse.y + 10);
				PlayState.instance.groundItems.add(apple);
			default:
		}
		groundItem.setPosition(PlayState.instance.blockMouse.x, PlayState.instance.blockMouse.y);
		PlayState.instance.groundItems.add(groundItem);

		pieDial.amount = 0.0;
		PlayState.instance.blockMouse.destroy();
		PlayState.instance.blockMouse = null;
		PlayState.instance.renderChunks();
		pieDial.visible = false;
		cursorBlock.visible = false;
	}

	public function blockPlace() {
		var block = new Block(mouseBlockX * World.BLOCKSIZE, mouseBlockY * World.BLOCKSIZE, PlayState.instance.player.curItem.type);
		PlayState.instance.world.getChunk(block.chunkX, block.chunkY)
		.setBlock(block, 1);
		PlayState.instance.player.removeItem(PlayState.instance.player.curItem);
	}

	public function itemUse() {
		if (PlayState.instance.player.curItem == null)
			return;
		
		switch (PlayState.instance.player.curItem.type) {
			case APPLE:
				if (PlayState.instance.player.health != 1.0) {
					PlayState.instance.player.heal(0.2);
					PlayState.instance.player.removeItem(PlayState.instance.player.curItem);
				}
			default:
		}
	}

    override public function update(elapsed) {
        super.update(elapsed);

		mouseHitbox.setPosition(FlxG.mouse.x - (mouseHitbox.width / 2), FlxG.mouse.y - (mouseHitbox.height / 2));

		/*
		doesnt work for no fucking reason

		if (FlxG.mouse.justPressed)
			FlxG.overlap(mouseHitbox, PlayState.instance.entities, (cursor, entity) -> {
				trace("hitting enemy");
				entity.hurt((PlayState.instance.player.curItem.type == WOODSWORD ? 0.4 : 0.1));
			}, FlxObject.updateTouchingFlags);
		*/

		pieDial.setPosition(FlxG.mouse.screenX - pieDial.width, FlxG.mouse.screenY - pieDial.height);

        lastMouseBlockX = mouseBlockX;
        lastMouseBlockY = mouseBlockY;

        FlxG.watch.addQuick("mouseBlockX", mouseBlockX = Std.int(FlxG.mouse.x / World.BLOCKSIZE));
		FlxG.watch.addQuick("mouseBlockY", mouseBlockY = Std.int(FlxG.mouse.y / World.BLOCKSIZE));

		cursorBlock.setPosition(mouseBlockX * World.BLOCKSIZE, mouseBlockY * World.BLOCKSIZE);
		breakStage.setPosition(cursorBlock.x, cursorBlock.y);
		breakStage.animation.play(Std.string(FlxMath.bound(Std.int(pieDial.amount / 0.20), 0, 4)));
		
        if (lastMouseBlockX != mouseBlockX || lastMouseBlockY != mouseBlockY) {
			pieDial.amount = 0.0;
			PlayState.instance.blockMouse = null;
			PlayState.instance._renderedBlocks1.forEach(block -> {
				if (block.worldX == mouseBlockX && block.worldY == mouseBlockY)
					PlayState.instance.blockMouse = block;
			});
        }

		if (PlayState.instance.blockMouse != null && isNearToPlayer(PlayState.instance.blockMouse)) {
			cursorBlock.visible = true;

			if (FlxG.mouse.pressed) {
				pieDial.amount += (elapsed * PlayState.instance.blockMouse.breakSpeed) * PlayState.instance.player.getMiningSpeed(PlayState.instance.blockMouse);
				pieDial.visible = true;
			}
		}
		else
			cursorBlock.visible = false;

		if (FlxG.mouse.justPressedRight) {
			if (isNearToPlayer(cursorBlock)) {
				if (PlayState.instance.blockMouse != null && PlayState.instance.blockMouse.type == WORKBENCH) {
					PlayState.instance.openSubState(new Crafting());
				}
				else if (PlayState.instance.blockMouse == null
					&& PlayState.instance.player.curItem != null
					&& PlayState.instance.player.curItem.type.canBePlaced()) {
					blockPlace();
				}
				else {
					itemUse();
				}
			}
			else {
				itemUse();
			}
		}

		if (!FlxG.mouse.pressed || pieDial.amount == 0) {
			pieDial.visible = false;
			pieDial.amount = 0;
		}
    }

	function isNearToPlayer(waht:FlxSprite) {
		return FlxMath.distanceBetween(waht, PlayState.instance.player) < World.BLOCKSIZE * 4;
	}

}