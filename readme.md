# Code Snippets

## Reload scene

`get_tree().reload_current_scene()`

## Get random number

|code|type|
|-|-|
|`randi() % max + min`|int|
|`randf() * max + min`|float|

Don't forget to randomize the seed by calling `randomize()` somewhere!

## Get mouse position

`var mouse_pos = get_viewport().get_mouse_position()`

## Spawn node

```python
onready var block_scene = preload("res://Block.tscn")

func _ready():
	var block = block_scene.instance()
	get_tree().get_root().add_child(block)
```

## KinematicBody2D Platformer Controller

```python
extends KinematicBody2D

const UP = Vector2(0, -1)

export var gravity = 30
export var acceleration = 50
export var max_speed = 400
export var jump_height = -500
export var variable_jump = true
export var variable_jump_height_limit = -20

var motion = Vector2()

func _physics_process(delta):
	
	motion.y += gravity
	if Input.is_action_pressed("ui_right") || Input.is_action_pressed("ui_left"):
		if Input.is_action_pressed("ui_right"):
			motion.x = min(motion.x + acceleration, max_speed)
		if Input.is_action_pressed("ui_left"):
			motion.x = max(motion.x - acceleration, -max_speed)
		
		if motion.x < 0:
			$Sprite.flip_h = true
		else:
			$Sprite.flip_h = false
	else:
		motion.x = 0
	
	if is_on_floor() && Input.is_action_just_pressed("ui_up"):
		motion.y = jump_height
	
	if variable_jump && !is_on_floor() && !Input.is_action_pressed("ui_up") && motion.y < variable_jump_height_limit:
			motion.y = variable_jump_height_limit
	
	motion = move_and_slide(motion, UP)
```
