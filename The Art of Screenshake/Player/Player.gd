extends KinematicBody2D

const UP = Vector2(0, -1)

export var gravity = 35
export var acceleration = 50
export var max_speed = 500
export var jump_height = -1050
export var camera_lerp_distance = 260
export var camera_lerp_weight = .08
export var bullet_inaccuracy = 200
export var knockback_amount = 100

var motion = Vector2()
var is_facing_left = false
var on_floor_last_frame
var muzzle_flash_radius
var camera_position = Vector2()

func _physics_process(delta):
	
	# movement & camera
	
	on_floor_last_frame = is_on_floor()
	
	motion.y += gravity
	var friction = false
	
	if Input.is_action_pressed("ui_right"):
		motion.x = min(motion.x + acceleration, max_speed)
		set_facing_direction(true)
		camera_position.x = camera_lerp_distance
	elif Input.is_action_pressed("ui_left"):
		motion.x = max(motion.x - acceleration, -max_speed)
		set_facing_direction(false)
		camera_position.x = -camera_lerp_distance
	else:
		#camera_position.x = 0
		pass
	
	$Camera2D.position.x = lerp($Camera2D.position.x, camera_position.x, camera_lerp_weight)
	
	$Gun.offset = Vector2(lerp($Gun.offset.x, -motion.x / 30, 0.8), lerp($Gun.offset.y, -motion.y / 30, 0.8))
	#print($Gun.offset)
	
	# fix screenshake offset
	$Camera2D.offset.x = lerp($Camera2D.offset.x, 0, camera_lerp_weight)
	$Camera2D.offset.y = lerp($Camera2D.offset.y, 0, camera_lerp_weight)
	
	# animation
	
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
	
	if Input.is_action_pressed("shoot") && $Timer.is_stopped():
		
		$Timer.start()
		
		var bullet = load("res://Bullet/Bullet.tscn").instance()
		bullet.set_position($Gun/Position2D.get_global_position())
		if is_facing_left:
			bullet.rotate(deg2rad(180))
			bullet.hspeed = -bullet.hspeed
		randomize()
		bullet.vspeed = rand_range(-bullet_inaccuracy, bullet_inaccuracy)
		get_node("/root").add_child(bullet)
		
		$AudioStreamPlayer.set_stream(preload("shoot.wav"))
		$AudioStreamPlayer.play()
		
		screenshake(7)
		
		if is_facing_left:
			motion.x += knockback_amount
			$Gun.rotation = deg2rad(50)
		else:
			motion.x -= knockback_amount
			$Gun.rotation = deg2rad(-50)
		
		muzzle_flash_radius = 35
	else:
		muzzle_flash_radius = 0
	
	# fix gun knockback
	
	$Gun.rotation = lerp($Gun.rotation, 0, 0.3)
	
	# update draw
	
	update()
	
func _draw():
	
	# muzzle flash
	draw_circle(Vector2($Gun/Position2D.position.x * 1.6, $Gun/Position2D.position.y), muzzle_flash_radius, Color(1, 1, 1))

func set_facing_direction(face_right):
	if face_right && is_facing_left:
		is_facing_left = false
		$AnimatedSprite.flip_h = false
		$Gun.flip_h = false
		$Gun.position.x = abs($Gun.position.x)
		$Gun/Position2D.position.x = abs($Gun/Position2D.position.x)
		#$CollisionShape2D.set_polygon(mirror_shape($CollisionShape2D.get_polygon()))
	elif !face_right && !is_facing_left:
		is_facing_left = true
		$AnimatedSprite.flip_h = true
		$Gun.flip_h = true
		$Gun.position.x = -abs($Gun.position.x)
		$Gun/Position2D.position.x = -abs($Gun/Position2D.position.x)
		#$CollisionShape2D.set_polygon(mirror_shape($CollisionShape2D.get_polygon()))

func mirror_shape(polygon): # mirror coordinates of polygon over Y axis
	for i in range(polygon.size()):
		polygon.set(i, Vector2(-polygon[i].x, polygon[i].y))
	return polygon

func screenshake(amount):
	var shake_vect = Vector2(rand_float(-1, 1), rand_float(-1, 1)).normalized() * amount
	while shake_vect.length() == 0:
		shake_vect = Vector2(rand_float(-1, 1), rand_float(-1, 1)).normalized() * amount
	#print(str(shake_vect) + " " + str(shake_vect.length()))
	$Camera2D.offset = shake_vect

func rand_float(min_val, max_val):
	randomize()
	return randf() * (max_val + 1) + min_val
