import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class PauseMenu extends FlxSubState {
	var options:FlxTypedSpriteGroup<FlxText>;
	var curSelected(default, set):Int = 0;
    
	override public function create() {
		PlayState.instance.persistentUpdate = false;

		var bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        bg.alpha = 0.6;
        bg.scrollFactor.set(0, 0);
        bg.screenCenter();
        add(bg);

        var swagText = new FlxText(0, 0, 0, "Paused", 24);
        swagText.screenCenter();
        swagText.y -= 30;
		swagText.scrollFactor.set(0, 0);
        add(swagText);

		add(options = new FlxTypedSpriteGroup<FlxText>());

		var resume = new FlxText(0, 0, 0, "Resume", 36);
		resume.y += 30;
		resume.ID = 0;
		resume.scrollFactor.set(0, 0);
		options.add(resume);

		var settings = new FlxText(0, 0, 0, "Options", 36);
		settings.y = resume.y + resume.height;
		settings.ID = 1;
		settings.scrollFactor.set(0, 0);
		options.add(settings);

        options.screenCenter();
        options.scrollFactor.set(0,0);

		camera = PlayState.instance.hudCam;
    }

	override public function update(elapsed) {
        super.update(elapsed);

		if (FlxG.keys.anyJustPressed([UP, W]))
			curSelected++;
		if (FlxG.keys.anyJustPressed([DOWN, S]))
			curSelected--;
        
		options.forEach(text -> {
			text.color = text.ID == curSelected ? FlxColor.YELLOW : FlxColor.WHITE;
			text.screenCenter(X);
		});

		if (FlxG.keys.anyJustPressed([ENTER, E, SPACE])) {
			switch (curSelected) {
				case 0:
					PlayState.instance.persistentUpdate = true;
					close();
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