extends Node2D

var letter
var centre
var hasBeenCast = false

signal casting_started(fromRune)

func _ready():
	$Letter.letter = letter
	centre = $HitArea/CollisionShape.position

func beingCast():
	hasBeenCast = true
	$Letter.color = Color.darkblue
	$Letter.update()

func _on_HitArea_input_event(_viewport, event, _shape_idx):
	if event.is_class("InputEventMouseButton"):
		if event.button_index == BUTTON_LEFT && event.pressed:
			print("Clicked - ", letter)
			emit_signal("casting_started", self)
