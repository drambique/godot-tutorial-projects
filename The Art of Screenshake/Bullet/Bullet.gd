extends RigidBody2D

export var hspeed = 3000
export var vspeed = 0

func _ready():
	set_axis_velocity(Vector2(hspeed, vspeed))

func _on_Timer_timeout():
	queue_free()

func _on_Bullet_body_entered(body):
	
	if !body.get_name() == "Player":
		
		var bullet_impact = load("res://BulletImpact.tscn").instance()
		bullet_impact.set_position($Position2D.get_global_position())
		if rad2deg(rotation) > -90 && rad2deg(rotation) < 90:
			bullet_impact.rotate(deg2rad(180))
		get_node("/root").add_child(bullet_impact)
		
		queue_free()
		
		if body.is_in_group("Enemy"):
			body.hurt()
			
			get_node("/root/Game/PauseGameTimeout").set_time(.02)
			get_tree().paused = true
			
		
		var temp_audio = load("res://TemporaryAudioObject.tscn").instance()
		temp_audio.set_position(self.position)
		temp_audio.set_stream(preload("hit.wav"))
		get_node("/root").add_child(temp_audio)
