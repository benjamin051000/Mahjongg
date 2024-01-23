extends Sprite2D

# Tile properties
var suit: String
var value: int
var faceup: bool
# The "orientation" of the tile (see perspective dicts)
var perspective = "bottom"

# Interaction and location parameters
var selected = false
var in_hand = false
var rest_point: Vector2  # This is provided by a hand.
var frozen = false
#var rest_nodes = []

const suits = ["crak", "boo", "dot", "honor"] # TODO BUG TERRIBLE! THIS IS NOT SHARED WITH ONE IN mahjongg.gd!!!

func set_perspective(persp: String):
	perspective = persp

func turn_face_down():
	# TODO add to setter
	faceup = false
	const face_down_offset = 2
	var perspective_offset = _get_perspective_offset()
	frame_coords = Vector2(perspective_offset, face_down_offset)


func _get_suit_offset() -> int:
	return suits.find(suit)


func turn_face_up():
	faceup = true
	# The face up tiles start at row index 3.
	const face_up_initial_offset = 3
	# Additional offset based off the perspective (which side of the tile can you see?)
	var perspective_offset = _get_perspective_offset()
	# Additional offset (from crak (crak == O regradless of perspective)) for the suit (see suit enum for indices)
	var suit_offset = _get_suit_offset()
	
	var y = face_up_initial_offset + perspective_offset + suit_offset
	frame_coords = Vector2(value - 1, y)  # Convert value to index
	

func _get_perspective_offset() -> int:
	# Returns the offset, in rows (x vals) from the very first face up tile
	# that matches the given tile set. OR, if face-down, returns the row
	if faceup:
		# These are rows in the spritesheet, which are "y" values.
		# These are the crak rows
		const sprite_perspective_offsets_faceup = {"bottom": 5, "top": 0, "left": 10, "right": 10}
		return sprite_perspective_offsets_faceup[perspective] 
	else:
		# All the face down sprites are in a single row, so these are x values
		const sprite_perspective_offsets_facedown = {"bottom": 0, "top": 2, "left": 6, "right": 6}
		return sprite_perspective_offsets_facedown[perspective]


func _validate_fields():
	# TODO use setters for this instead for extra validation!
	# Value is not an index. We convert it to one when appropriate internally.
	assert(value >= 1 and value <= 9)
	assert(suit in suits)
	assert(Vector2.ZERO <= rest_point and rest_point <= Vector2(1600,900))
	#assert(perspective in ["bottom", "top", "left", "right"])


# Called when the node enters the scene tree for the first time.
func _ready():
	_validate_fields()
	
	SignalBus.tile_added_to_hand.connect(_on_hand_collect_tile_into_hand)
	SignalBus.tile_removed_from_hand.connect(_on_hand_remove_tile_from_hand)
	SignalBus.hand_reorder_tiles.connect(_on_hand_reorder_tiles)
	
	turn_face_up()
		
#	rest_nodes = get_tree().get_nodes_in_group("zone")
#	rest_point = rest_nodes[0].global_position  # Default resting position (may not be necessary)
#	rest_nodes[0].select()  # Update color indicators


func _on_control_gui_input(_event):
	if Input.is_action_just_pressed("click") and not frozen:  # TODO does one of the nodes already have a frozen flag?
		selected = true
		move_to_front()
		turn_face_up()


func _physics_process(delta):
	if selected:
		global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)
		#rotation = lerp_angle(rotation, 0, 10 * delta)
#		look_at(get_global_mouse_position())
	#elif in_hand:
	else:
		global_position = lerp(global_position, rest_point, 10 * delta)
#		rotation = lerp_angle(rotation, 0, 10 * delta)


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			selected = false
#			var shortest_dist = 75
#			for child in rest_nodes:
#				var distance = global_position.distance_to(child.global_position)
#				if distance < shortest_dist:
#					child.select()
#					rest_point = child.global_position
#					shortest_dist = distance


func _on_hand_collect_tile_into_hand(tile: Area2D, lerp_to: Vector2) -> void:
	# Skip if the signal isn't for me.
	if tile != $Area2D:
		return
	
	in_hand = true
	
	print("[Tile] updating rest point...")
	rest_point = lerp_to


func _on_hand_remove_tile_from_hand(tile: Area2D):
	# Skip if it isn't for me.
	if tile != $Area2D:
		return

	print("[Tile] out of hand")
	in_hand = false


func _on_hand_reorder_tiles(area: Area2D, new_rest_point: Vector2):
	if area != $Area2D:
		return
	rest_point = new_rest_point
