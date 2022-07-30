import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;

class Gui extends FlxGroup {
	public var swagSlots:FlxSpriteGroup;
    public var frontLayer:FlxGroup;

	public var itemName:FlxText;
	public var playerIcon:FlxSprite;

    public function new() {
        super();

		frontLayer = new FlxGroup();

        var slots = 6;

        // AlGeBRa WilL bE UseFUl iN LiFe!!11
        //for fuck sake i will never try to guess what discount is today on fish in tesco by calculating the mass of sun
        var _width = World.BLOCKSIZE * slots + 10 * (slots + 1) + 155;
        
		var bg = new FlxSprite().makeGraphic(_width, 135, FlxColor.BLACK);
        bg.alpha = 0.6;
        bg.y = FlxG.height - bg.height;
        bg.screenCenter(X);
		//bg.framePixels.applyFilter(new BlurFilter(12, 12));
        add(bg);

		itemName = new FlxText(0, 0, 0, "", 20, true);
		itemName.font = "assets/fonts/vcr.ttf";
		itemName.screenCenter(X);
		itemName.y = bg.y - itemName.height - 50;
        itemName.alpha = 0;
		add(itemName);

        playerIcon = new FlxSprite().makeGraphic(100, 100);
		playerIcon.y = bg.y + 20;
        playerIcon.x = bg.x + 25;
        add(playerIcon);

		var healthBar = new FlxBar(0, 0, FlxBarFillDirection.RIGHT_TO_LEFT, World.BLOCKSIZE * slots + 10 * (slots - 1) - 10, 10, PlayState.instance.player, "health", 0, 1);
		healthBar.y = bg.y + bg.height - 25;
		healthBar.x = playerIcon.x + playerIcon.width + 30;
        add(healthBar);

		var healthText = new FlxText(0, 0, 0, "Health", 20, true);
        healthText.font = "assets/fonts/vcr.ttf";
        healthText.y = (healthBar.y - healthText.height) - 5;
        healthText.x = healthBar.width / 2 - healthText.width / 2 + healthBar.x;
		add(healthText);

		add(swagSlots = new FlxSpriteGroup(slots));

		for (i in 0...slots) {
			var slot = new Slot();
			slot.makeGraphic(World.BLOCKSIZE, World.BLOCKSIZE, FlxColor.GRAY);
            slot.y = bg.y + 25;
			slot.x = (bg.x + bg.width) - ((i + 1) * World.BLOCKSIZE) - ((i + 1) * 10) - 15;
            slot.ID = i;
            swagSlots.add(slot);
			frontLayer.add(slot.amountText);
        }

		add(PlayState.instance.player.inventory);
		add(frontLayer);
    }

    override function update(elapsed) {
        super.update(elapsed);

		playerIcon.color = (PlayState.instance.player.attackCooldown == 0 ? FlxColor.WHITE : FlxColor.GRAY);
        
		if (FlxG.mouse.wheel != 0) {
			PlayState.instance.player.curSlot += FlxG.mouse.wheel > 0 ? 1 : -1;

			onItemChange();
        }
    }

    public function onItemChange() {
		if (PlayState.instance.player.curItem == null)
            return;

		itemName.text = PlayState.instance.player.curItem.type.getName();
		itemName.screenCenter(X);
		itemName.alpha = 1;
		new FlxTimer().start(1, timer -> {
			FlxTween.num(1, 0, 2, null, f -> itemName.alpha = f);
		});
    }
}