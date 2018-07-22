extends KinematicBody2D

const UP = Vector2(0, -1)

export var health = 15
export var gravity = 35
export var acceleration = 20
export var max_speed = 300
export var on_start_move_left = false

var move_right = true

func _ready():
	if on_start_move_left:
		move_right = false

var motion = Vector2()

func _physics_process(delta):
	
	motion.y += gravity
	var friction = false
	
	if move_right:
		motion.x = min(motion.x + acceleration, max_speed)
	else:
		motion.x = max(motion.x - acceleration, -max_speed)
	
	motion = move_and_slide(motion, UP)
	
	if health < 1:
		queue_free()

func _on_LeftCollider_body_entered(body):
	if body.is_in_group("UnmovableSolid") || body.is_in_group("Enemy"):
		move_right = true

func _on_RightCollider_body_entered(body):
	if body.is_in_group("UnmovableSolid") || body.is_in_group("Enemy"):
		move_right = false
