# Code Snippets

## Reload scene

`get_tree().reload_current_scene()`

## Get random number

|code|type|
|-|-|
|`randi() % (max + min) + min`|int|
|`randf() * (max + min) + min`|float|

Don't forget to randomize the seed by calling `randomize()` somewhere!

## Get mouse position

`var mouse_pos = get_viewport().get_mouse_position()`

## Spawn scene

```
onready var block_scene = preload("res://Block.tscn")

func _ready():
	var block = block_scene.instance()
	get_tree().get_root().add_child(block)
```

## KinematicBody2D platformer controller

```
extends KinematicBody2D

const UP = Vector2(0, -1)

export var gravity = 20
export var acceleration = 30
export var max_speed = 300
export var jump_height = -500
export var jump_halt_limit = -200
export var floor_friction = 0.2 # Slow down by 20% every frame
export var air_friction = 0.05 # Slow down by 5% every frame

var motion = Vector2()

func _ready():
	pass

func _physics_process(_delta):
	
	var key_right = Input.is_action_pressed("ui_right")
	var key_left = Input.is_action_pressed("ui_left")
	var key_jump = Input.is_action_pressed("ui_up")
	var key_just_jump = Input.is_action_just_pressed("ui_up")
	
	if key_right && !key_left:
		motion.x = min(motion.x + acceleration, max_speed)
		$Sprite.flip_h = false
	elif key_left && !key_right:
		motion.x = max(motion.x - acceleration, -max_speed)
		$Sprite.flip_h = true
	elif is_on_floor():
		motion.x = lerp(motion.x, 0, floor_friction)
	else:
		motion.x = lerp(motion.x, 0, air_friction)
	
	motion.y += gravity
	
	if key_just_jump && is_on_floor():
		motion.y = jump_height
	elif !key_jump && motion.y < jump_halt_limit:
		motion.y = jump_halt_limit
	
	motion = move_and_slide(motion, UP)
```

## KinematicBody2D top-down controller

```
extends KinematicBody2D

const UP = Vector2(0, 0)

export var speed = 300

func _physics_process(delta):

	var motion = Vector2()
	
	if Input.is_action_pressed("ui_right"):
		motion.x += 1
	if Input.is_action_pressed("ui_left"):
		motion.x -= 1
	if Input.is_action_pressed("ui_up"):
		motion.y -= 1
	if Input.is_action_pressed("ui_down"):
		motion.y += 1
	
	motion = motion.normalized() * speed
	
	motion = move_and_slide(motion, UP)
```