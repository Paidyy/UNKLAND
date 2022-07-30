import flixel.math.FlxMath;
import Item.ItemRoot;
import flixel.group.FlxGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.group.FlxSpriteGroup;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxSubState;

class Crafting extends FlxSubState {
	public static var instance:Crafting;

	public var swagSlots:FlxTypedGroup<CraftingSlot>;
	public var swagItems:Array<ItemRoot>;
	public var swagNames:FlxTypedGroup<FlxText>;

	public var curSlot:Int = -1;
	public var titleText:FlxText;

	public var ingridients:FlxGroup;
	public var sideBar:FlxSprite;

	var unlimitedResources:Bool = false;

	override public function create() {
        super.create();

		instance = this;

		var bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0.4;
		bg.scrollFactor.set(0, 0);
		bg.screenCenter();
		add(bg);

		var guiBg = new FlxSprite().makeGraphic(Std.int(FlxG.width / 1.2), Std.int(FlxG.height / 1.2), FlxColor.BLACK);
		guiBg.alpha = 0.4;
		guiBg.scrollFactor.set(0, 0);
		guiBg.screenCenter();
		add(guiBg);

		sideBar = new FlxSprite(guiBg.x, guiBg.y).makeGraphic(325, Std.int(guiBg.height), FlxColor.fromString("#A37C1A"));
		sideBar.scrollFactor.set(0, 0);
		add(sideBar);
		
		add(titleText = new FlxText(sideBar.x + 15, sideBar.y + 25, 0, "Choose Item", 30));

		add(ingridients = new FlxGroup());

		var create = new FlxButton(0, 0, "CRAFT", createCallback);
		create.label.size = 60;
		create.label.offset.y = -(create.height);
		create.makeGraphic(Std.int(sideBar.width / 1.2), 120, FlxColor.fromString("#44C635"));
        create.updateHitbox();
        create.setPosition(
            sideBar.x + 25,
		    sideBar.y + sideBar.height - (create.height + 25)
        );
        add(create);

		swagItems = [];
		add(swagNames = new FlxTypedGroup<FlxText>());

		add(swagSlots = new FlxTypedGroup<CraftingSlot>());

        for (i in 0...Recipe.recipes.length) {
			var slot = new CraftingSlot();
			slot.makeGraphic(World.BLOCKSIZE * 2, World.BLOCKSIZE * 2, FlxColor.GRAY);
			// unreadable but works!
			slot.y = sideBar.y + 25 + (i % 7 == 0 && i != 0 ? (slot.height + ((i % 7) + 1)) + 25 : 0);
			slot.x = (sideBar.x + sideBar.width + ((i + 1) * 25)) + i * (World.BLOCKSIZE * 2);
			slot.ID = i;
			swagSlots.add(slot);
			
			// (germans name items like dicks, it's a funny language tbh)
			swagItems.push(ItemRoot.cloneFromItem(Recipe.recipes[i].swagItem));
			var dasCoolDing = swagItems[i];
			dasCoolDing.x = slot.x + slot.width / 4;
			dasCoolDing.y = slot.y + slot.height / 4;
			add(dasCoolDing);
			add(slot.amountText);
        }
        
        camera = PlayState.instance.hudCam;
    }

    override public function update(elapsed) {
        super.update(elapsed);

		if (FlxG.keys.justPressed.ESCAPE || FlxG.keys.justPressed.E) {
			close();
		}
    }

    public function createCallback() {
		if (unlimitedResources) {
			PlayState.instance.player.addItem(new Item(Crafting.instance.swagItems[curSlot].type, Crafting.instance.swagItems[curSlot].amount));
			return;
		}
		
		if (Crafting.instance.swagItems[curSlot] == null)
			return;

		for (item in Recipe.recipes[curSlot].ingridients)
			if (!PlayState.instance.player.inventoryContainsItem(item))
				return;
		for (item in Recipe.recipes[curSlot].ingridients) {
			PlayState.instance.player.removeItem(item, item.amount);
		}
		PlayState.instance.player.addItem(new Item(Crafting.instance.swagItems[curSlot].type, Crafting.instance.swagItems[curSlot].amount));
    }
}

class CraftingSlot extends FlxButton {
	public var amountText:FlxText;

	override public function new(?X:Float = 0, ?Y:Float = 0) {
		super(X, Y, "", () -> {
			Crafting.instance.curSlot = ID;
			Crafting.instance.titleText.text = Crafting.instance.swagItems[ID].type.getName();

			Crafting.instance.ingridients.clear();
			Crafting.instance.swagNames.clear();
			for (i in 0...Recipe.recipes[ID].ingridients.length) {
				var daItem = ItemRoot.cloneFromItem(Recipe.recipes[ID].ingridients[i]);
				daItem.setPosition(
					Crafting.instance.sideBar.x + 25,
					Crafting.instance.titleText.y + Crafting.instance.titleText.height + 35
				);
				daItem.y += i * daItem.height + i * 25;
				Crafting.instance.ingridients.add(daItem);
				
				var amountTextIngridient = new FlxText(0, 0, 0, "", 15, true);
				amountTextIngridient.font = "assets/fonts/vcr.ttf";
				amountTextIngridient.text = "" + daItem.amount;
				amountTextIngridient.setPosition(
					daItem.x + daItem.width - amountTextIngridient.width,
					daItem.y + daItem.height - amountTextIngridient.height
				);
				Crafting.instance.ingridients.add(amountTextIngridient);
				
				var itemName = new FlxText(0, 0, 0, daItem.type.getName(), 25, true);
				itemName.font = "assets/fonts/vcr.ttf";
				itemName.setPosition(
					daItem.x + daItem.width + 5,
					daItem.y + daItem.height / 4
				);
				itemName.color = PlayState.instance.player.inventoryContainsItem(daItem) ? FlxColor.LIME : FlxColor.RED;
				Crafting.instance.swagNames.add(itemName);
			}
		});

		amountText = new FlxText(0, 0, 0, "", 15, true);
		amountText.font = "assets/fonts/vcr.ttf";
	}

	override public function update(elapsed) {
		super.update(elapsed);

		if (Crafting.instance.swagItems[ID] != null && Crafting.instance.swagItems[ID].amount != 1) {
			amountText.text = "" + Crafting.instance.swagItems[ID].amount;
			amountText.setPosition(
				Crafting.instance.swagItems[ID].x + Crafting.instance.swagItems[ID].width - amountText.width, 
				Crafting.instance.swagItems[ID].y + Crafting.instance.swagItems[ID].height - amountText.height
			);
		}
		else {
			amountText.text = '';
		}
	}
}