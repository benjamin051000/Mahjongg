extends Node

func spawn_tiles():
	const tile_scene = preload("res://tile.tscn")
	const suits = Common.Suit  # TODO what type is this? Appears to work... Interesting.
	# Start with the three numerical suits.
	for suit in [suits.CRAK, suits.BOO, suits.DOT]:
		for value in range(1, 10):
			for i in 4: # Four of each tile
				var tile = tile_scene.instantiate()
				tile.suit = suit
				tile.value = value
				tile.position = Vector2(300 + 50 * value, 200 + 100 * suit)
				#tile.position = Vector2(randi_range(100, 1500), randi_range(100, 700))
				tile.rest_point = tile.position
				#tile.frozen = true
				tile.add_to_group("tiles")
				add_child(tile)
	
	# Winds and Dragons
	# TODO these don't really have a "value", but it's convenient to match the normal tiles for now
	for value in range(1, 8):
		for i in 4:
			var tile = tile_scene.instantiate()
			tile.suit = Common.Suit.HONOR
			tile.value = value
			tile.position = Vector2(300 + 50 * (value + i), 200 + 100 * tile.suit)
			#tile.position = Vector2(randi_range(100, 1500), randi_range(100, 700))
			tile.rest_point = tile.position
			tile.frozen = false
			tile.add_to_group("tiles")
			add_child(tile)
	
	# Flowers and Jokers
	for i in 16:
		var tile = tile_scene.instantiate()
		# TODO we don't have textures for these yet, so just use the ? tile for now I guess
		tile.suit = Common.Suit.HONOR
		tile.value = 9  # NOTE: Recall that values are 1-9, indexing happens internally.
		tile.position = Vector2(300 + 50 * (i + 1), 200 + 100 * (tile.suit + 1))
		#tile.position = Vector2(randi_range(100, 1500), randi_range(100, 700))
		tile.rest_point = tile.position
		tile.frozen = false
		tile.add_to_group("tiles")
		add_child(tile)

func build_horizontal_wall(wall_length: int, tiles: Array, x: int, bottom_tile_y: int, second_level_offset: int, x_y_offset: Vector2):
	# WARNING: This consumes the tiles array! Send a copy to it. TODO just reference it
	# Two levels tall. First one has no offset because it's the "origin".
	for level_offset in [Vector2(0, 0), Vector2(0, second_level_offset)]:
		for i in wall_length:
			# Move each tile in the array to its spot on the wall.
			# TODO make a wall building animation that is representative of real life
			# TODO make tiles face down
			var tile = tiles.pop_front()
			tile.rest_point = Vector2(x, bottom_tile_y) + x_y_offset * i + level_offset
			
			if level_offset:
				tile.move_to_front()
			
			tile.frozen = false
			#tile.change_perspective("bottom")
			await get_tree().create_timer(0.2).timeout # waits for 1 second
	
	# Do it again, but slightly offset to show two levels
	#for i in wall_length:
		#var tile = tiles.pop_front()
		#tile.move_to_front()
		#tile.rest_point = wall_first_spot_upper + tile_offset * i + horiz_wall_offset * n
		#tile.frozen = false
		#tile.change_perspective(perspective)
		#await get_tree().create_timer(0.03).timeout # waits for 1 second
	
	
func build_wall():
	const wall_length = 19
	
	#get_tree().call_group("tiles", "turn_face_down")  # TODO add this back in
	var tiles = get_tree().get_nodes_in_group("tiles")
	
	tiles.shuffle()
	
	build_horizontal_wall(wall_length, tiles, 300, 750, -20, Vector2(52, 0))
	# TODO is tiles consumed at this point?


# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.new_game.connect(_on_new_game)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass

func _on_new_game():
	print("[mahjongg] Starting a new game...")
	remove_child($TitleScreen)
	spawn_tiles()
	build_wall()
