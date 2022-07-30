class Recipe {
    public static var recipes(get, default):Array<Recipe>;

	public var swagItem:Item;
	public var ingridients:Array<Item>;

    public function new(item:Item, ingridientos:Array<Item>) {
        swagItem = item;
        ingridients = ingridientos;
    }

	static function get_recipes():Array<Recipe> {
        if (recipes == null) {
            recipes = [];
            recipes.push(new Recipe(new Item(WOODPLANK, 2), [new Item(WOOD)]));
            recipes.push(new Recipe(new Item(ROPE), [new Item(COTTON, 2)]));
			recipes.push(new Recipe(new Item(WOODPICKAXE), [new Item(ROPE, 2), new Item(WOODPLANK, 8)]));
			recipes.push(new Recipe(new Item(WOODSWORD), [new Item(ROPE, 3), new Item(WOODPLANK, 6)]));
			recipes.push(new Recipe(new Item(TORCH, 4), [new Item(WOOD, 2), new Item(STONE, 1)]));
        }

		return recipes;
	}
}