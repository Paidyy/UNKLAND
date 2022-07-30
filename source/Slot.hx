import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

class Slot extends FlxSprite {
    var curItem:Item;
    public var amountText:FlxText;

	override public function new(?X:Float = 0, ?Y:Float = 0) {
        super(X, Y);

		amountText = new FlxText(0, 0, 0, "", 15, true);
		amountText.font = "assets/fonts/vcr.ttf";
    }

    override public function update(elapsed) {
        super.update(elapsed);
        
		color = ID == PlayState.instance.player.curSlot ? FlxColor.WHITE : FlxColor.GRAY;

		curItem = PlayState.instance.player.inventory.members[ID];

		if (curItem != null) {
			if (curItem.amount != 1) {
				amountText.text = "" + curItem.amount;
				amountText.setPosition(curItem.x + curItem.width - amountText.width, curItem.y + curItem.height - amountText.height);
			}
			else
				amountText.text = '';
			curItem.setPosition(x, y);
		}
		else {
			amountText.text = '';
		}
    }
}