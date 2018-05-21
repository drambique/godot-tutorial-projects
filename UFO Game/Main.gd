extends Node2D

var hit = false

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	$LoseLabel.hide()

func _process(delta):
	if !$UFO.hit && hit:
		print("lose")
		$UFO.lose = true
		$LoseLabel.show()
	elif $UFO.hit:
		$UFO.clicks += 1
		$ClicksLabel.text = "Clicks: " + str($UFO.clicks)
	$UFO.hit = false
	hit = false

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT && event.pressed:
		hit = true
