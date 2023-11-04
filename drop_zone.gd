extends Marker2D

func _draw():
	draw_circle(Vector2.ZERO, 75, Color.BLANCHED_ALMOND)

func select():
	for child in get_tree().get_nodes_in_group("zone"):
		child.deselect()
	modulate = Color.SKY_BLUE

func deselect():
	modulate = Color.WHITE
