import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class MainMenu extends FlxState {
    var options:FlxTypedGroup<FlxText>;
    var curSelected(default, set):Int = 0;
    
    override public function create() {
		var bg = new FlxSprite(0, 0).loadGraphic("assets/images/mainTheme.png");
        bg.alpha = 0.5;
        add(bg);

		add(options = new FlxTypedGroup<FlxText>());

        var newGame = new FlxText(0, 0, 0, "New Game", 36);
        newGame.screenCenter(XY);
        newGame.y -= newGame.height;
		newGame.ID = 0;
		options.add(newGame);

		var option = new FlxText(0, 0, 0, "Options", 36);
		option.screenCenter(XY);
		option.y = newGame.y + newGame.height;
        option.ID = 1;
		options.add(option);
    }

    override public function update(elapsed) {
        super.update(elapsed);

		if (FlxG.keys.anyJustPressed([UP, W]))
            curSelected++;
		if (FlxG.keys.anyJustPressed([DOWN, S]))
			curSelected--;

        options.forEach(text -> {
			text.color = text.ID == curSelected ? FlxColor.YELLOW : FlxColor.WHITE;
			text.size = text.ID == curSelected ? 40 : 36;
            text.screenCenter(X);
        });

        if (FlxG.keys.justPressed.ENTER) {
            switch (curSelected) {
                case 0:
                    FlxG.switchState(new LoadingState());
                case 1:
                    openSubState(new OptionsSub());
            }
        }
    }

	function set_curSelected(value:Int):Int {
		if (value >= options.length)
			value = 0;
		if (value < 0)
			value = options.length - 1;
		return curSelected = value;
	}
}