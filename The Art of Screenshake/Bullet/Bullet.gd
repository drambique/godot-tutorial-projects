extends RigidBody2D

export var speed = 1600

func _ready():
	set_axis_velocity(Vector2(speed, 0))

func _on_Timer_timeout():
	queue_free()

func _on_Bullet_body_entered(body):
	queue_free()
	
	if body.is_in_group("Enemy"):
		body.hurt()
	
	var temp_audio = load("res://TemporaryAudioObject.tscn").instance()
	temp_audio.set_position(self.position)
	temp_audio.set_stream(preload("hit.wav"))
	get_node("/root").add_child(temp_audio)
