extends Node

var player

func _ready():
	player = AudioStreamPlayer.new()
	player.stream = load("res://Kelly C Laughter 3.wav")
	self.add_child(player)

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		print("play laugh")
		player.play()
