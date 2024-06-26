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
			tile.frozen = true
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
		tile.frozen = true
		tile.add_to_group("tiles")
		add_child(tile)

func build_horizontal_wall(
	wall_length: int, # Number of tiles in a wall
	tiles: Array, # Array referencing Tile nodes
	x: int, # Starting x-coord of wall (NOTE which appears to be the center of the tile)
	bottom_tile_y: int, # Y-coord of the bottom row
	second_level_offset: int, # y-offset of top level
	x_y_offset: Vector2i  # Size of tile, used as offset. TODO can we implicitly get this from the Tile size?
):
	# WARNING: This consumes the tiles array! TODO send a copy, or just reference it.
	# Two levels tall. First one has no offset because it's the "origin".
	for level_offset in [Vector2i.ZERO, Vector2i(0, second_level_offset)]:
		for i in wall_length:
			# Move each tile in the array to its spot on the wall.
			var tile = tiles.pop_front()
			tile.rest_point = Vector2i(x, bottom_tile_y) + x_y_offset*i + level_offset
			
			# Ensure the top level appears on top of the bottom level.
			if level_offset:
				tile.move_to_front()
			
			tile.frozen = false
			#tile.change_perspective("bottom")  # TODO is this required?
			await get_tree().create_timer(0.1).timeout
	
func build_vertical_wall(
	wall_length: int,
	tiles: Array,
	x: int,  # x-coord of wall
	y: int,  # Starting y-coord of wall
	second_level_offset: int, 
	x_y_offset: Vector2i
):
	for level_offset in [Vector2i.ZERO, Vector2i(0, second_level_offset)]:
		for i in wall_length:
			var tile = tiles.pop_front()
			tile.rest_point = Vector2i(x, y) + x_y_offset*i + level_offset
			
			# HACK: These get built top-to-bottom, so *every* time a new one gets placed,
			# it's supposed to be in the front (from our perspective).
			tile.move_to_front()
			
			tile.frozen = false
			 
			# TODO make this nicer to deal with
			tile.set_perspective("left")
			#tile.turn_face_up()
			tile.turn_face_down()
			
			await get_tree().create_timer(0.1).timeout


func build_wall():
	const wall_length = 19
	
	get_tree().call_group("tiles", "turn_face_down")  # TODO add this back in
	var tiles = get_tree().get_nodes_in_group("tiles")
	
	tiles.shuffle()
	
	# Right now we're hard-coded to 1600x900, so assume those values when making adjustments.
	build_horizontal_wall(wall_length, tiles, 325,      900-140, -20, Vector2i(52, 0)) # lower
	build_horizontal_wall(wall_length, tiles, 325,      60, -20, Vector2i(52, 0)) # upper
	build_vertical_wall(wall_length, tiles,   325-21*3,      50, -20, Vector2i(0, 52-12)) # left
	build_vertical_wall(wall_length, tiles,   1600-325+17*3, 50, -20, Vector2i(0, 52-12)) # right
	# TODO is tiles consumed at this point? I believe it is.


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
