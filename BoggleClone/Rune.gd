extends Node2D

var letter
var centre
var hasBeenCast = false

signal casting_started(fromRune)
signal rune_entered(fromRune)

func _ready():
	$Letter.letter = letter
	centre = $HitArea/CollisionShape.position

func beingCast():
	hasBeenCast = true
	$Letter.color = Color.darkblue
	$Letter.update()

func castingStopped():
	hasBeenCast = false
	$Letter.color = Color.cornflower
	$Letter.update()

func _on_HitArea_input_event(_viewport, event, _shape_idx):
	if event.is_class("InputEventMouseButton"):
		if event.button_index == BUTTON_LEFT && event.pressed:
			emit_signal("casting_started", self)


func _on_HitArea_mouse_entered():
	emit_signal("rune_entered", self)
