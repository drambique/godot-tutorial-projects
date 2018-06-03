extends RigidBody2D

var speed = 200
var rotation_speed = 80
var max_speed = 150

# slave keyword means this var is set by other masters
slave var slave_position = Vector2()
slave var slave_rotation = 0

func _ready():
	pass

func _process(delta):
	
	if is_network_master():
		# move forward when up key is pressed
		if Input.is_action_pressed("ui_up"):
			# Vector2(cos(rotation), sin(rotation)) corresponds to forward vector of ship
			add_force(Vector2(0, 0), Vector2(cos(rotation), sin(rotation) * speed * delta))
		
		# limit velocity to max speed
		if get_linear_velocity().length() > max_speed:
			set_linear_velocity(get_linear_velocity().normalized() * max_speed)
		
		# rotate when left or right key is pressed
		if Input.is_action_pressed("ui_left"):
			set_angular_velocity(-rotation_speed * delta)
		if Input.is_action_pressed("ui_right"):
			set_angular_velocity(rotation_speed * delta)
			
		# master informs new variables
		rset_unreliable("slave_position", position)
		rset_unreliable("slave_position", rotation)
	else:
		# slave receives variables and updates locally
		position = slave_position
		position = slave_rotation
	
