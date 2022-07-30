import flixel.FlxSprite;

class WorldObject extends FlxSprite {
	public var worldX(get, set):Int;
	public var worldY(get, set):Int;

	public var chunkX(get, never):Int;
	public var chunkY(get, never):Int;
	
	public var z:Int;
    
	function get_worldX():Int {
		return Std.int(x / World.BLOCKSIZE);
	}

	function set_worldX(value:Int):Int {
		return Std.int(x = value * World.BLOCKSIZE);
	}

	function get_worldY():Int {
		return Std.int(y / World.BLOCKSIZE);
	}

	function set_worldY(value:Int):Int {
		return Std.int(y = value * World.BLOCKSIZE);
	}

	function get_chunkX():Int {
		return Std.int(worldX / World.CHUNKSIZE);
	}

	function get_chunkY():Int {
		return Std.int(worldY / World.CHUNKSIZE);
	}
}