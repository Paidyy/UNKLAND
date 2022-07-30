import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.math.FlxMath;

/**
    Class for ground and inventory items
**/
class Item extends ItemRoot {
	public var onGround(default, set):Bool = false;
	public var size = 0.6;

    public function new(Type:StackType, ?Amount:Int = 1) {
        super(Type, Amount);

		setGraphicSize(Std.int(width * size), Std.int(height * size));
    }

	override public function update(elapsed) {
		super.update(elapsed);

		if (onGround && PlayState.instance.player.inventory.length < 6) {
			setPosition(FlxMath.lerp(x, PlayState.instance.player.x, 0.01), FlxMath.lerp(y, PlayState.instance.player.y, 0.01));

            
			if (FlxMath.distanceBetween(this, PlayState.instance.player) < 30) {
				onGround = false;

				var swagBool = true;
				for (item in PlayState.instance.player.inventory) {
					if (item.type == type) {
						item.amount += amount;
						PlayState.instance.groundItems.remove(this);
						this.destroy();
						swagBool = false;
					}
				}
				if (swagBool) {
					Util.moveFromGroup(this, PlayState.instance.groundItems, PlayState.instance.player.inventory);
				}
				PlayState.instance.gui.onItemChange();
			}
		}
	}

	function set_onGround(value:Bool):Bool {
        switch (value) {
            case true:
                camera = PlayState.instance.swagCam;
                setGraphicSize(Std.int(width * size), Std.int(height * size));
            case false:
				//Util.moveFromGroup(this, PlayState.instance.player.inventory, PlayState.instance.groundItems);
                camera = PlayState.instance.hudCam;
                setGraphicSize(Std.int(width * size + 0.1), Std.int(height * size + 0.1));
        }
		return onGround = value;
	}

	override function clone() {
		var newItem = new Item(type, amount);
		newItem.size = size;
		newItem.onGround = onGround;
		return newItem;
	}
}

class ItemRoot extends FlxSprite {
	public var type:StackType;
    public var amount = 1;
    
	public function new(Type:StackType, ?Amount:Int = 1) {
        super();

		type = Type;
        amount = Amount;

        switch (type) {
			case STONE:
                loadGraphic("assets/images/blocks/stone.png");
			case TOUCHIT:
                loadGraphic("assets/images/items/grass.png");
			case TORCH:
				loadGraphic("assets/images/blocks/torch.png");
            case TREE, WOOD:
                type = WOOD;
				loadGraphic("assets/images/blocks/wood.png");
            case WORKBENCH:
				loadGraphic("assets/images/blocks/workbench.png");
            case WOODPICKAXE:
				loadGraphic("assets/images/items/woodPickaxe.png");
			case WOODSWORD:
				loadGraphic("assets/images/items/woodSword.png");
            case WOODPLANK:
				loadGraphic("assets/images/blocks/woodPlank.png");
			case STICK:
				loadGraphic("assets/images/items/stick.png");
			case COTTONPLANT, COTTON:
				type = COTTON;
				loadGraphic("assets/images/items/cotton.png");
			case ROPE:
				loadGraphic("assets/images/items/rope.png");
			case POPPY:
				loadGraphic("assets/images/blocks/poppy.png");
			case DANDELION:
				loadGraphic("assets/images/blocks/dandelion.png");
            case APPLE:
                loadGraphic("assets/images/items/apfel.png");
            default:
        }
    }

    override function clone() {
		return new ItemRoot(type, amount);
    }
    
    public static function cloneFromItem(item:Item):ItemRoot {
		return new ItemRoot(item.type, item.amount);
    }
}

@:enum abstract StackType(Int) from Int to Int {
	var WATER = 0;
	var SAND = 1;
	var GRASS = 2;
	var STONE = 3;
	var TORCH = 4;
	var TREE = 5;
	var TOUCHIT = 6;
    var WOOD = 7;
    var WORKBENCH = 8;
    var WOODPICKAXE = 9;
    var WOODSWORD = 10;
    var WOODPLANK = 11;
    var STICK = 12;
    var COTTONPLANT = 13;
	var COTTON = 14;
    var ROPE = 15;
    var POPPY = 16;
    var DANDELION = 17;
    var APPLE = 18;

	public function getName():String {
		switch (this) {
            case WATER:
                return "Water";
            case SAND:
                return "Sand";
            case GRASS:
                return "Dirt";
            case STONE:
                return "Stone";
            case TORCH:
                return "Torch";
            case TREE:
                return "Tree";
            case TOUCHIT:
                return "Grass";
            case WOOD:
                return "Log";
            case WORKBENCH:
                return "Workbench";
            case WOODPICKAXE:
                return "Wooden Pickaxe";
            case WOODSWORD:
                return "Wooden Sword";
            case WOODPLANK:
                return "Plank";
            case STICK:
                return "Stick";
            case COTTONPLANT:
                return "Cotton Plant";
            case COTTON:
                return "Cotton";
            case ROPE:
                return "Rope";
            case POPPY:
                return "Poppy";
            case DANDELION:
                return "Dandelion";
            case APPLE:
                return "Apple";
		}
        return "missingst";
	}

    public function canBePlaced() {
        switch (this) {
			case WOODPICKAXE, WOODSWORD, STICK, COTTON, APPLE:
                return false;
            default:
                return true;
        }
    }
}