extends RigidBody2D

export var speed = 1600

func _ready():
	set_axis_velocity(Vector2(speed, 0))

func _on_Timer_timeout():
	queue_free()

func _on_Bullet_body_entered(body):
	queue_free()
	if (body.is_in_group("Enemy")):
		body.health -= 1
