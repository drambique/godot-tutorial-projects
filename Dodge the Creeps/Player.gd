extends Area2D

signal hit

export (int) var SPEED # players movement px/sec
var velocity = Vector2() # the player's movement vector
var screensize # size of the game window

func _ready():
	screensize = get_viewport_rect().size
	
	hide()
	
func _process(delta):
	
	# Move player
	velocity = Vector2()
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * SPEED
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
		
	# Prevent player from leaving screen
	position += velocity * delta
	position.x = clamp(position.x, 0, screensize.x)
	position.y = clamp(position.y, 0, screensize.y)
	
	# Flip sprite based on direction
	if velocity.x != 0:
		$AnimatedSprite.animation = "right"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0
		
func start(pos): # Reset player when starting a new game
	position = pos
	show()
	$CollisionShape2D.disabled = false

func _on_Player_body_entered( body ):
	hide() # Player disappears after being hit
	emit_signal("hit")
	$CollisionShape2D.disabled = true # Prevent multiple signal triggers
