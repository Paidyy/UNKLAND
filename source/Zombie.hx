import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import flixel.math.FlxMath;
import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;

class Zombie extends WorldObject {
    var blockingBlock:Block = null;
    var breakTime:Float = 0;
    var attackCooldown:Float = 0;

	public function new(x:Float = 0, y:Float = 0) {
		super(x, y);

		frames = FlxAtlasFrames.fromSparrow("assets/images/zombie.png", "assets/images/zombie.xml");
		animation.addByPrefix("idle", "idle");
		animation.addByPrefix("walk", "walk");
		animation.play("idle");

		width = World.BLOCKSIZE * 0.8;
		height = World.BLOCKSIZE * 0.8;
		centerOffsets();

		antialiasing = true;
    }

    override public function hurt(damage:Float) {
		PlayState.instance.player.attackCooldown = 1;

		health = health - damage;
        if (health <= 0) {
            PlayState.instance.entities.remove(this);
			destroy();
        }
        else {
            colorTransform.redOffset += 255;

			new FlxTimer().start(0.5, timer -> if (exists) colorTransform.redOffset = 0);
        }
    }

    override public function update(elapsed) {
        super.update(elapsed);

        //what the fuck happened with flixel path finding
        x += (PlayState.instance.player.x > x ? 1 : -1);
		y += (PlayState.instance.player.y > y ? 1 : -1);
        
		angle = (FlxMath.absInt(PlayState.instance.player.worldX) >= worldX ? -90 : 90);
		flipY = !(FlxMath.absInt(PlayState.instance.player.worldY) >= worldY);

		animation.play("walk");

		FlxG.collide(this, PlayState.instance._renderedBlocks1, (d1, d2) -> blockingBlock = d2);

		attackCooldown = FlxMath.bound(attackCooldown - elapsed, 0, FlxMath.MAX_VALUE_INT);

        try {
			if (blockingBlock != null) {
				if (FlxMath.distanceBetween(this, blockingBlock) <= 2 * World.BLOCKSIZE)
					breakTime += elapsed;
				else
					breakTime = 0;

				if (FlxMath.bound(breakTime, 0, (blockingBlock.type == STONE ? 15 : 5)) == (blockingBlock.type == STONE ? 15 : 5)) {
					breakTime = 0;
					blockingBlock.destroy();
					blockingBlock = null;
					PlayState.instance.renderChunks();
				}
			}
			else
				breakTime = 0;

			if (FlxMath.distanceBetween(this, PlayState.instance.player) <= 1 * World.BLOCKSIZE && attackCooldown == 0) {
				attackCooldown = 2;
				PlayState.instance.player.hurt(0.1);
			}
        }
        catch (exc) {

        }

		if (FlxG.mouse.justPressed
			&& FlxMath.distanceBetween(this, PlayState.instance.playerCursor.mouseHitbox) <= 2 * World.BLOCKSIZE
			&& FlxMath.distanceBetween(PlayState.instance.player, PlayState.instance.playerCursor.mouseHitbox) <= 3 * World.BLOCKSIZE &&
            PlayState.instance.player.attackCooldown == 0)
			if (PlayState.instance.player.curItem != null) {
				hurt((PlayState.instance.player.curItem.type == WOODSWORD ? 0.4 : 0.1));
			}
			else {
				hurt(0.1);
			}
    }
}