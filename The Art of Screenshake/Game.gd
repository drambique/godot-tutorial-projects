extends Node

func _process(delta):
	
	# quick quit
	
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
