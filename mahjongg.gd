extends Node

func spawn_tiles():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.new_game.connect(_on_new_game)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_new_game():
	print("[mahjongg] Starting a new game...")
	remove_child($TitleScreen)
	spawn_tiles()
