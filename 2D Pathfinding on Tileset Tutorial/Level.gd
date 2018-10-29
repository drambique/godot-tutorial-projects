extends Node

signal map_update

# preloaded for instancing
var mob = preload("res://Mob.tscn")

onready var start_pos = $StartPos.position
onready var end_pos = $EndPos.position
onready var nav = $Navigation2D
onready var map = $Navigation2D/TileMap

func _ready():
	set_process_input(true)

func _input(event):
	if Input.is_action_just_pressed("left_mouse"):
		var tile_clicked = map.world_to_map(event.position)
		
		# flip tile
		if map.get_cell(tile_clicked.x, tile_clicked.y) == 0:
			map.set_cell(tile_clicked.x, tile_clicked.y, 1)
		else:
			map.set_cell(tile_clicked.x, tile_clicked.y, 0)
	
	if Input.is_action_just_released("left_mouse"):
		# signal mobs to map change
		emit_signal("map_update")


func _on_Spawn_Timer_timeout():
	var m = mob.instance()
	add_child(m)
	m.position = start_pos
	m.goal = end_pos
	m.nav = nav
	connect("map_update", m, "update_path") # run update_path when map_upate signal received
