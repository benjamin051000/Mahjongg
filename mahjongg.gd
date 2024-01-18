extends Node

func spawn_tiles():
	var tile_scene = preload("res://tile.tscn")
	const suits = ["crak", "boo", "dot", "honor"]  # TODO BUG TERRIBLE! THIS IS NOT SHARED WITH ONE IN mahjongg.gd!!!
	for suit in suits.slice(0, 3):
		for value in 9:
			for i in 4:  # Four of each tile
				var tile = tile_scene.instantiate()
				tile.suit = suit
				tile.value = value
				tile.position = Vector2(300 + 50 * (value + i), 200 + 100 * suits.find(suit))
				add_child(tile)
	
	# Winds and Dragons
	# TODO these don't really have a "value", but it's convenient to match the normal tiles for now
	for value in 7:
		for i in 4:
			var tile = tile_scene.instantiate()
			tile.suit = "honor"
			tile.value = value
			tile.position = Vector2(randi_range(100, 400), randi_range(600, 800))
			add_child(tile)
	# Flowers and Jokers
	for i in 16:
		var tile = tile_scene.instantiate()
		# TODO we don't have textures for these yet, so just use the ? tile for now I guess
		tile.suit = "honor"
		tile.value = 8
		tile.position = Vector2(randi_range(1300, 1500), randi_range(100, 400))
		add_child(tile)
	 
# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.new_game.connect(_on_new_game)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_new_game():
	print("[mahjongg] Starting a new game...")
	remove_child($TitleScreen)
	spawn_tiles()
