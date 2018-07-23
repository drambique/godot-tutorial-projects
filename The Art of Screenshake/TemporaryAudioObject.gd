extends AudioStreamPlayer2D

func _on_TemporaryAudioObject_finished():
	queue_free()
