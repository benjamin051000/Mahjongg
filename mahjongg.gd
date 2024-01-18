extends Node

func spawn_tiles():
	var tile_scene = preload("res://tile.tscn")
	const suits = ["crak", "boo", "dot"]  # TODO BUG TERRIBLE! THIS IS NOT SHARED WITH ONE IN mahjongg.gd!!!
	for suit in suits:
		for value in 9:
			for i in 4:  # Four of each tile
				var tile = tile_scene.instantiate()
				tile.suit = suit
				tile.value = value
				tile.position = Vector2(300 + 50 * (value + i), 200 + 100 * suits.find(suit))
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
