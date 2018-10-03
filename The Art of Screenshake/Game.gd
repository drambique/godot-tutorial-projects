extends Node

func _ready():
	
	# hide cursor
	
	Input.set_mouse_mode(1)

func _process(delta):
	
	# quick quit
	
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
