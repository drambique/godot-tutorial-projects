extends Area

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	rotate_x(deg2rad(60 * delta))
	rotate_y(deg2rad(60 * delta))


func _on_Box_body_entered(body):
	if body is KinematicBody:
		queue_free()
