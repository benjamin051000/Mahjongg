extends Node

signal tile_added_to_hand(tile: Area2D, new_resting_point: Vector2)
signal hand_reorder_tiles(tile: Area2D, new_resting_point: Vector2) # TODO combine these?
signal tile_removed_from_hand(tile: Area2D)
