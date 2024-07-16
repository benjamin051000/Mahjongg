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

func _on_control_gui_input(_event):
	if Input.is_action_just_pressed("click") and not frozen:  # TODO does one of the nodes already have a frozen flag?
		get_tree().call_group("dice", "picked_up")
		selected = true
		move_to_front()
		# TODO get the other dice and bunch them up.
		# Make them maintain momentum and bounce off walls as they are rolled.

func _physics_process(delta):
	if selected or other_dice_is_picked_up:
		global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)

func picked_up():
	if not selected:
		other_dice_is_picked_up = true
		
func dropped():
	if not selected:
		other_dice_is_picked_up = false
		
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			get_tree().call_group("dice", "dropped")
			selected = false
