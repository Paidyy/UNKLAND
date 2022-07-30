package;

import flixel.FlxG;
import flixel.util.FlxSave;

using StringTools;

class Options {
    public static var fps:Int;
	public static var accurateChunkLoading:Bool;

    static var _save:FlxSave;

    public static function initialize() {
        _save = new FlxSave();
		_save.bind("save");

		if (_save.data.fps == null)
			_save.data.fps = 60;
		if (_save.data.accurateChunkLoading == null)
			_save.data.accurateChunkLoading = true;

		fps = _save.data.fps;
		accurateChunkLoading = _save.data.accurateChunkLoading;
    }

	public static function saveAll() {
		_save.data.fps = fps;
		_save.data.accurateChunkLoading = accurateChunkLoading;
	}

	public static function applyAll() {
		FlxG.updateFramerate = fps;
		FlxG.drawFramerate = fps;
	}

	/*
	now i know why people hate javascript

    public static function loadAndSave() {
		for (i in getClassOptions()) {
			if (!exists(i)) {
				set(i, Reflect.field(Options, i));
			}
		}
        _save.flush();
		for (i in getClassOptions()) {
			Reflect.setField(Options, i, get(i));
		}
    }

	public static function get(variable):Dynamic {
		return Reflect.field(_save.data, variable);
	}

	public static function set(variable, value) {
		Reflect.setField(_save.data, variable, value);
	}

	public static function exists(variable):Dynamic {
		if (get(variable) != null) {
			return true;
		}
		return false;
	}

	public static function saveAll() {
		for (i in getClassOptions()) {
			set(i, Reflect.field(Options, i));
		}
		_save.flush();
	}

	static function getClassOptions():Array<String> {
		var arr:Array<String> = [];
		for (i in Type.getClassFields(Options)) {
			if (Reflect.field(Options, i) != i) {
				if (!i.startsWith("_")) {
					arr.push(i);
				}
			}
		}
		return arr;
	}
	*/
}