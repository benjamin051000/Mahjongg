extends RigidBody2D
class_name Draggable2D

# Impulse cap, used when releasing the object.
# I think it's pixels/sec.
@export var impulse_limit_pps := 300

# Use these signals if you want to hook into pickup/drop events.
signal picked_up
signal dropped

var held := false

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
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
			impulse = impulse.clamp(
				Vector2(-impulse_limit_pps, -impulse_limit_pps), 
				Vector2(impulse_limit_pps, impulse_limit_pps)
			)
			
			_drop(impulse)
