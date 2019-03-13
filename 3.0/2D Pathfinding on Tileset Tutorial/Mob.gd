extends Sprite

var speed = 150
var nav = null setget set_nav # the nav2d node
var path = [] # array holding points to travel through
var goal = Vector2()
var coord_margin = 2 # how far away mob can be from path coordinate to consider it arrived

func _ready():
	pass

func set_nav(new_nav):
	nav = new_nav
	update_path()

func update_path():
	path = nav.get_simple_path(position, goal, false)
	
	if path.size() == 0: # reach destination or stuck (trapped from destination)
		queue_free()

func _process(delta):
	
	#print(path)
	
	if path.size() > 1:
		
		# move along path
		
		var distance = position.distance_to(path[0])
		if distance > coord_margin:
			position = position.linear_interpolate(path[0], (speed * delta) / distance)
		else:
			path.remove(0)
	
	else:
		queue_free()
