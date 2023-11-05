extends Area2D

signal collect_tile_into_hand(lerp_to: Vector2)
signal remove_tile_from_hand

# TODO what if you draw flowers? There are 8 total (?)
const MAX_HAND_SIZE = 14

# TODO find a way to fetch this dynamically
const WIDTH_PER_TILE = 52 + 6  # 3 px per side, so 6 between tiles

var hand_size = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_entered(area: Area2D) -> void:
	print("welcome to the hand!")
	hand_size += 1
	print("hand size:", hand_size)
	var x_offset = position.x - $ColorRect.size.x / 2
	var next_open_slot_x = hand_size * WIDTH_PER_TILE + x_offset
	var location_to_lerp_to = Vector2(next_open_slot_x, position.y)  # TODO the next available slot
	emit_signal("collect_tile_into_hand", location_to_lerp_to)



func _on_area_exited(area: Area2D):
	print("bye from the hand")
	hand_size -= 1
	print("hand size:", hand_size)
	emit_signal("remove_tile_from_hand")
