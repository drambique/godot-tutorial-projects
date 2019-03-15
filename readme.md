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
export var speed = 300
export var jump_height = -500
export var variable_jump = true
export var variable_jump_height_limit = -100

var motion = Vector2()

func _physics_process(delta):
	
	motion.y += gravity
	
	motion.x = 0
	if Input.is_action_pressed("ui_right"):
		motion.x += speed
	if Input.is_action_pressed("ui_left"):
		motion.x -= speed
		
	if motion.x < 0:
		$Sprite.flip_h = true
	else:
		$Sprite.flip_h = false
	
	if is_on_floor() && Input.is_action_just_pressed("ui_up"):
		motion.y = jump_height
	
	if variable_jump && !is_on_floor() && !Input.is_action_pressed("ui_up") && motion.y < variable_jump_height_limit:
	 	motion.y = variable_jump_height_limit
	
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