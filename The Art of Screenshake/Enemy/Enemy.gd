extends KinematicBody2D

const UP = Vector2(0, -1)

export var health = 15
export var gravity = 35
export var acceleration = 20
export var max_speed = 300
export var on_start_move_left = false

var move_right = true

var motion = Vector2()

func _ready():
	if on_start_move_left:
		move_right = false
	pass

func _physics_process(delta):
	
	# movement
	
	motion.y += gravity
	var friction = false
	
	if move_right:
		motion.x = min(motion.x + acceleration, max_speed)
		$AnimationPlayer.playback_speed = 1
	else:
		motion.x = max(motion.x - acceleration, -max_speed)
		$AnimationPlayer.playback_speed = -1
	
	motion = move_and_slide(motion, UP)

func _on_LeftCollider_body_entered(body):
	if body.is_in_group("UnmovableSolid") || body.is_in_group("Enemy") && body != self:
#		print("hit wall on left: " + str(body))
		move_right = true

func _on_RightCollider_body_entered(body):
	if body.is_in_group("UnmovableSolid") || body.is_in_group("Enemy") && body != self:
#		print("hit wall on right: " + str(body))
		move_right = false

func hurt(damage = 1):
	
	health -= damage
	
	if health > 0:
		var temp_audio = load("res://TemporaryAudioObject.tscn").instance()
		temp_audio.set_position(self.position)
		temp_audio.set_stream(preload("hurt.wav"))
		get_node("/root").add_child(temp_audio)
	else:
		queue_free()
		
		var temp_audio = load("res://TemporaryAudioObject.tscn").instance()
		temp_audio.set_position(self.position)
		temp_audio.set_stream(preload("death.wav"))
		get_node("/root").add_child(temp_audio)
		
		# create sprite node
		var corpse = Sprite.new()
		corpse.set_name("corpse")
		corpse.set_texture(preload("res://enemy_corpse.png"))
		corpse.set_position(self.position)
		get_node("/root").add_child(corpse)
	
	# Tint sprite white using CanvasModulate node
	$Sprite.modulate = Color(10, 10, 10, 10)
	$Sprite/CanvasModulate/Timer.start()

func _on_Timer_timeout():
	# Untint sprite using CanvasModulate node
	$Sprite.modulate = Color(1, 1, 1, 1)
