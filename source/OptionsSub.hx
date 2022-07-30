import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class OptionsSub extends FlxSubState {
	var options:FlxTypedGroup<FlxText>;
	var curSelected(default, set):Int = 0;

	override public function create() {
		var bg = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0.6;
		bg.scrollFactor.set(0, 0);
		add(bg);

		add(options = new FlxTypedGroup<FlxText>());

		var fps = new FlxText(0, 0, 0, "FPS: " + Options.fps, 24);
		fps.screenCenter(X);
		fps.y += fps.height;
		fps.ID = 0;
		fps.scrollFactor.set(0, 0);
		options.add(fps);

		var accChunkLoad = new FlxText(0, 0, 0, "Accurate Chunk Loading: " + Options.accurateChunkLoading, 24);
		accChunkLoad.screenCenter(X);
		accChunkLoad.y = fps.y + fps.height;
		accChunkLoad.ID = 1;
		accChunkLoad.scrollFactor.set(0, 0);
		options.add(accChunkLoad);
	}
    
	override public function update(elapsed) {
		super.update(elapsed);

		if (FlxG.keys.anyJustPressed([UP, W]))
			curSelected++;
		if (FlxG.keys.anyJustPressed([DOWN, S]))
			curSelected--;

		options.forEach(text -> {
			switch (text.ID) {
                case 0:
					text.text = '${(curSelected == text.ID ? ">" : "")} FPS: ' + Options.fps;
                case 1:
					text.text = '${(curSelected == text.ID ? ">" : "")} Accurate Chunk Loading: ' + Options.accurateChunkLoading;
            }
			text.screenCenter(X);
		});

		if (FlxG.keys.anyJustPressed([LEFT, A]))
			switch (curSelected) {
				case 0:
					Options.fps--;
				case 1:
					Options.accurateChunkLoading = !Options.accurateChunkLoading;
			}
        
		if (FlxG.keys.anyJustPressed([RIGHT, D]))
			switch (curSelected) {
				case 0:
					Options.fps++;
				case 1:
					Options.accurateChunkLoading = !Options.accurateChunkLoading;
			}

        if (FlxG.keys.justPressed.ESCAPE) {
            Options.saveAll();
            Options.applyAll();
            close();
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