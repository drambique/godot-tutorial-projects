extends KinematicBody2D

const UP = Vector2(0, -1)

export var gravity = 35
export var acceleration = 50
export var max_speed = 500
export var jump_height = -1050

var motion = Vector2()
var is_facing_left = false
var on_floor_last_frame

func _physics_process(delta):
	
	# movement
	
	on_floor_last_frame = is_on_floor()
	
	motion.y += gravity
	var friction = false
	
	if Input.is_action_pressed("ui_right"):
		motion.x = min(motion.x + acceleration, max_speed)
		set_facing_direction(true)
	elif Input.is_action_pressed("ui_left"):
		motion.x = max(motion.x - acceleration, -max_speed)
		set_facing_direction(false)
	
	if Input.is_action_pressed("ui_left") || Input.is_action_pressed("ui_right"):
		if is_on_floor():
			$AnimatedSprite.play("walk")
		else:
			$AnimatedSprite.play("idle")
	else:
		friction = true
		$AnimatedSprite.play("idle")
	
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			motion.y = jump_height
			
			$AudioStreamPlayer.set_stream(preload("jump.wav"))
			$AudioStreamPlayer.play()
		if friction:
			motion.x = lerp(motion.x, 0, 0.2) # Slow down by 20% every frame
	elif friction:
			motion.x = lerp(motion.x, 0, 0.05) # Slow down by 5% every frame
	
	motion = move_and_slide(motion, UP)
	
	if (!on_floor_last_frame && is_on_floor()): # detect when player lands
		$AudioStreamPlayer.set_stream(preload("land.wav"))
		$AudioStreamPlayer.play()
	
	# shooting
	
	if Input.is_action_just_pressed("shoot"):
		var bullet = load("res://Bullet/Bullet.tscn").instance()
		bullet.set_position($Gun/Position2D.get_global_position())
		if $AnimatedSprite.flip_h:
			bullet.rotate(deg2rad(180))
			bullet.speed = -bullet.speed
		get_node("/root").add_child(bullet)
		
		$AudioStreamPlayer.set_stream(preload("shoot.wav"))
		$AudioStreamPlayer.play()

func set_facing_direction(face_right):
	if face_right && is_facing_left:
		is_facing_left = false
		$AnimatedSprite.flip_h = false
		$Gun.flip_h = false
		$Gun.position.x = abs($Gun.position.x)
		$Gun/Position2D.position.x = abs($Gun/Position2D.position.x)
		$CollisionShape2D.set_polygon(mirror_shape($CollisionShape2D.get_polygon()))
	elif !face_right && !is_facing_left:
		is_facing_left = true
		$AnimatedSprite.flip_h = true
		$Gun.flip_h = true
		$Gun.position.x = -abs($Gun.position.x)
		$Gun/Position2D.position.x = -abs($Gun/Position2D.position.x)
		$CollisionShape2D.set_polygon(mirror_shape($CollisionShape2D.get_polygon()))

func mirror_shape(polygon): # mirror coordinates of polygon over Y axis
	for i in range(polygon.size()):
		polygon.set(i, Vector2(-polygon[i].x, polygon[i].y))
	return polygon