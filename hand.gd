extends Area2D

#signal collect_tile_into_hand(lerp_to: Vector2)
#signal remove_tile_from_hand
# Use the SignalBus from now on!

# TODO what if you draw flowers? There are 8 total (?)
# Well, flowers immediately go face up. So those probably don't count.
const MAX_HAND_SIZE = 14

# TODO find a way to fetch this dynamically
const TILE_PADDING = 4 # on both sides of one tile (so 2x in-between two tiles)
const WIDTH_PER_TILE = 52 + TILE_PADDING * 2
const hand_pad = TILE_PADDING + 52 / 2

func _ready():
	print(14 * WIDTH_PER_TILE)

var hand_size = 0

func _on_area_entered(area: Area2D) -> void:
	hand_size += 1
	print("hand size:", hand_size)
	
	var x_start_of_hand = position.x - $ColorRect.size.x / 2
	var next_open_slot_x = x_start_of_hand - hand_pad + hand_size * WIDTH_PER_TILE
	var location_to_lerp_to = Vector2(next_open_slot_x, position.y)  # TODO the next available slot
	SignalBus.tile_added_to_hand.emit(area, location_to_lerp_to)



func _on_area_exited(area: Area2D):
	hand_size -= 1
	print("hand size:", hand_size)
	SignalBus.tile_removed_from_hand.emit()
