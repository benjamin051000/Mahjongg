extends RigidBody2D

var selected := false

# For determining speed
var old_mouse := Vector2.ZERO
var new_mouse := Vector2.ZERO
var speed := Vector2.ZERO
@export var friction := 0.95
@export var max_speed := Vector2(2000, 2000)

@export var render_shadow := true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

func _physics_process(delta: float) -> void:
	if selected:
		# Update mouse
		old_mouse = new_mouse
		new_mouse = get_global_mouse_position()
		var potential_speed = (new_mouse - old_mouse) * delta * Vector2(1000, 1000)
		speed = potential_speed
		#speed = Vector2(1000, 0)
		print(speed)
		global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)
		$CollisionShape2D.scale = lerp($CollisionShape2D.scale, Vector2(5, 5), 10 * delta)
		$Sprite2D.scale = lerp($Sprite2D.scale, Vector2(5, 5), 10 * delta)
		if render_shadow:
			$Shadow.scale = lerp($Shadow.scale, Vector2(5, 5), 10 * delta)
			$Shadow.color.a = lerp($Shadow.color.a, 128.0, 10 * delta)
		
		#scale = Vector2(5, 5)
		
	else:
		# Naturally come down to 0
		global_position += speed * delta
		speed *= friction
		# TODO emulate "dice bounce"
		# TODO emulate "shadow"
		$CollisionShape2D.scale = lerp($CollisionShape2D.scale, Vector2(3, 3), 10 * delta)
		$Sprite2D.scale = lerp($Sprite2D.scale, Vector2(3, 3), 10 * delta)
		if render_shadow:
			$Shadow.scale = lerp($Shadow.scale, Vector2(3, 3), 10 * delta)
			$Shadow.color.a = lerp($Shadow.color.a, 0.0, 10 * delta)
		
		#$Sprite2D.scale = Vector2(1, 1)
		#speed = clamp(speed, Vector2.ZERO, max_speed)
		# update mouse speed
	global_position = global_position.clamp(Vector2.ZERO, Vector2(get_viewport().size))
	# TODO bounce off the walls
	

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			print("picked up")
			selected = true
		#else:
			#print("released")  # TODO this may need to be global or something
			#selected = false

func _input(event: InputEvent):
	if event is InputEventMouseButton:
		if not event.pressed:
			print("released")
			selected = false
	
