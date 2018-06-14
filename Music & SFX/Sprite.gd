extends Sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	get_viewport().audio_listener_enable_2d = true
	

func _process(delta):
	position.x = get_viewport().get_mouse_position().x
	position.y = get_viewport().get_mouse_position().y
	
	if Input.is_action_just_pressed("left_click"):
		$AudioStreamPlayer2D.play()
