extends Timer

func set_time(time = 1):
	wait_time = time

func _process(delta):
	print(time_left)
	if get_tree().paused && is_stopped():
		start()

func _on_PauseGameTimeout_timeout():
	get_tree().paused = false
