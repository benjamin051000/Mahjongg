extends RigidBody2D
class_name PhysicsTile

signal picked_up
signal dropped

var held := false

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			print("clicked")
			_pickup()

func _physics_process(delta: float) -> void:
	if held:
		#global_transform.origin = lerp(global_transform.origin, get_global_mouse_position(), 25 * delta)
		global_position = lerp(global_position, get_global_mouse_position(		), 25 * delta)
		#position = lerp(position, get_global_mouse_position(), 25 * delta)

func _pickup():
	#if held:
		#return # TODO necessary?
	freeze = true
	held = true
	picked_up.emit(self)

func _drop(impulse=Vector2.ZERO):
	#if not held:
		#return
	freeze = false
	apply_central_impulse(impulse)
	held = false
	dropped.emit(self)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if held and not event.pressed:
			var impulse = Input.get_last_mouse_velocity()
			print("impulse:", impulse)
			const limit = 300
			impulse = impulse.clamp(Vector2(-limit, -limit), Vector2(limit, limit))
			
			_drop(impulse)
