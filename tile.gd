extends Sprite2D

# Tile properties
var suit: String
var value: int
var faceup: bool

# Interaction and location parameters
var selected = false
var in_hand = false
var rest_point: Vector2  # This is provided by a hand.
var frozen = false
#var rest_nodes = []


func freeze():
	frozen = true


func unfreeze():
	frozen = false


func turn_face_down():
	frame_coords = Vector2(0, 2)
	faceup = false


func turn_face_up():
	# Get the right value based on what was set before calling add_child()
	const suits = ["crak", "boo", "dot", "honor"] # TODO BUG TERRIBLE! THIS IS NOT SHARED WITH ONE IN mahjongg.gd!!!
	const first_suit_offset = 3
	frame_coords = Vector2(value, first_suit_offset + suits.find(suit))
	faceup = true


func change_perspective(perspective: String):
	# There are y values
	const sprite_perspective_offsets_faceup = {"bottom": 1, "right": 3, "top": 0, "left": 2}
	# These are x values
	const sprite_perspective_offsets_facedown = {"bottom": 0, "right": 6, "top": 2, "left": 6}
	if perspective not in sprite_perspective_offsets_facedown and perspective not in sprite_perspective_offsets_faceup:
		print("ERROR")
		get_tree().quit(1)
		
	if faceup:
		frame_coords.y = 3 + sprite_perspective_offsets_faceup[perspective]
	else:
		frame_coords.x = sprite_perspective_offsets_facedown[perspective]
	
	
# Called when the node enters the scene tree for the first time.
func _ready():
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
