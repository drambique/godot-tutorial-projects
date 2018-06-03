extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_HostButton_pressed():
	ConnectionManager.on_host_game()


func _on_JoinButton_pressed():
	var ip = $Panel/JoinRect/IPAddress.text
	ConnectionManager.on_join_game(ip)
