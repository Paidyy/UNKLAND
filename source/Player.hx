import flixel.FlxG;
import flixel.math.FlxMath;
import Item.ItemRoot;
import Item.StackType;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.util.FlxColor;

class Player extends WorldObject {

	public var hitbox:FlxSprite;
	public var inventory:FlxTypedGroup<Item>;
	public var curSlot(default, set):Int = 5;
	public var curItem(get, default):Item;

	public var attackCooldown:Float = 0;

	public function new(x:Float = 0, y:Float = 0) {
		super(x, y);

		/*
		loadGraphic("assets/images/old-player.png", true, 44, 42);
		animation.add('STANDO', [0]);
		animation.add('UP', [1]);
		animation.add('LEFT', [2]);
		animation.add('DOWN', [3]);
		animation.add('RIGHT', [4]);
		animation.play("STANDO");
		*/

		frames = FlxAtlasFrames.fromSparrow("assets/images/player.png", "assets/images/player.xml");
		animation.addByPrefix("idle", "idle");
		animation.addByPrefix("walk", "walk");
		animation.play("idle");

		width = World.BLOCKSIZE * 0.8;
		height = World.BLOCKSIZE * 0.8;
		centerOffsets();

		antialiasing = true;

		inventory = new FlxTypedGroup<Item>(6);
		inventory.add(new Item(WORKBENCH));
    }
	
	public function invSize():Int {
		var count = 0;
		for (item in inventory) {
			if (item != null && item.exists)
				count++;
		}
		return count;
	}

	override public function update(elapsed) {
		super.update(elapsed);

		attackCooldown = FlxMath.bound(attackCooldown - elapsed, 0, FlxMath.MAX_VALUE_INT);
		health = FlxMath.bound(health + 0.0001, 0, 1);
	}

	public function getMiningSpeed(block:Block):Float {
		var preVar:Null<Float> = null;
		if (curItem != null)
			switch (curItem.type) {
				case WOODPICKAXE:
					preVar = 2;
				default:
			}
		if (preVar == null) {
			switch (block.type) {
				case STONE:
					preVar = 0.0;
				default:
					preVar = 1.0;
			}
		}
		return preVar;
	}

	public function heal(amount:Float) {
		health = FlxMath.bound(health + amount, 0, 1);
	}

	override public function hurt(damage:Float):Void {
		health = FlxMath.bound(health - damage, 0, 1);
		if (health <= 0) {
			FlxG.switchState(new MainMenu());
		}
	}

	public function inventoryContainsItem(item:ItemRoot) {
		for (invItem in inventory.members) {
			if (invItem == null)
				continue;
			if (invItem.type == item.type && invItem.amount >= item.amount)
				return true;
		}
		return false;
	}

	public function inventoryItemIndex(item:ItemRoot) {
		for (i in 0...inventory.members.length) {
			if (inventory.members[i] == null || item == null)
				continue;
			if (inventory.members[i].type == item.type && inventory.members[i].amount >= item.amount)
				return i;
		}
		return -1;
	}

	public function addItem(item:Item) {
		if (inventoryContainsItem(item)) {
			inventory.members[inventoryItemIndex(item)].amount += item.amount;
			item.destroy();
			item = null;
			return;
		}
		inventory.add(item);
	}

	public function removeItem(item:Item, ?amount = 1) {
		var swagItem = inventory.members[inventoryItemIndex(item)];
		if (swagItem == null)
			return;
		
		if (swagItem.amount <= amount) {
			inventory.remove(swagItem);
			swagItem.destroy();
			swagItem = null;
		}
		else
			swagItem.amount -= amount;
		PlayState.instance.renderChunks();
	}

	function set_curSlot(value:Int):Int {
		if (value >= PlayState.instance.gui.swagSlots.length)
			value = 0;
		if (value < 0)
			value = PlayState.instance.gui.swagSlots.length - 1;
		return curSlot = value;
	}

	function get_curItem():Item {
		return inventory.members[curSlot];
	}
}