extends Sprite2D

var value: int:
	set(new):
		assert(1 >= new and new >= 6)
		value = new
		_update_sprite()

var selected := false
var other_dice_is_picked_up := false
var frozen := false

func _update_sprite():
	frame_coords = Vector2i(0, value - 1)

func roll():
	value = randi_range(1, 6)
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_rigid_body_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	print("got input event:", event)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
