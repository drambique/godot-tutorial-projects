extends Area2D

var speed = 100
var direction = Vector2()
var width
var height
var hit = false
var lose = false
var clicks = 0

func _ready():
	position = get_viewport_rect().size / 2
	width = get_viewport_rect().size.x
	height = get_viewport_rect().size.y
	
	# create random direction
	direction.x = rand_range(-1, 1)
	direction.y = rand_range(-1, 1)
	direction = direction.normalized()
	
func _process(delta):
	
	# move UFO
	position += direction * speed * delta
	
	# bounce UFO off the edges of the screen
	if position.x < 0:
		direction.x = -direction.x
	elif position.x > width:
		direction.x = -direction.x
	if position.y < 0:
		direction.y = -direction.y
	elif position.y > height:
		direction.y = -direction.y

func _on_UFO_input_event(viewport, event, shape_idx):
	if lose:
		# if lose is true, don't do anything else in the function
		return
	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT && event.pressed:
		
		# create random direction
		direction.x = rand_range(-1, 1)
		direction.y = rand_range(-1, 1)
		direction = direction.normalized()
		
		# set random position on screen
		position.x = rand_range(1, width - 1)
		position.y = rand_range(1, height - 1)
		
		# increase speed
		speed += 20
		
		hit = true
		
		$HitSound.play()
