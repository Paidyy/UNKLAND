import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;

class WorldBarrier extends FlxGroup {
    public var left:FlxSprite;
	public var right:FlxSprite;
	public var up:FlxSprite;
	public var down:FlxSprite;

    public function new() {
        super(4);

        left = new FlxSprite().makeGraphic(1, Std.int(FlxG.worldBounds.width), FlxColor.TRANSPARENT);
        left.immovable = true;
        add(left);

		right = new FlxSprite(FlxG.worldBounds.width - 1).makeGraphic(1, Std.int(FlxG.worldBounds.width), FlxColor.TRANSPARENT);
		right.immovable = true;
		add(right);

		up = new FlxSprite().makeGraphic(Std.int(FlxG.worldBounds.height), 1, FlxColor.TRANSPARENT);
		up.immovable = true;
		add(up);

		down = new FlxSprite(0, FlxG.worldBounds.height - 1).makeGraphic(Std.int(FlxG.worldBounds.height), 1, FlxColor.TRANSPARENT);
		down.immovable = true;
		add(down);
    }
}