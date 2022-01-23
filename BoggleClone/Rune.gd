extends Node2D

var letter
var centre
var hasBeenCast = false
var col
var row
export var baseColor = Color.royalblue
export var castingColor = Color.darkslateblue
export var highlightColor = Color.gold

signal casting_started(fromRune)
signal rune_entered(fromRune)

func _ready():
	$Letter.letter = letter
	centre = $HitArea/CollisionShape.position

func beingCast():
	hasBeenCast = true
	$Letter.color = castingColor
	$Letter.update()
	$Particles.emitting = true

func castingStopped():
	hasBeenCast = false
	$Letter.color = baseColor
	$Letter.update()
	$Particles.emitting = false

func set_highlight(valid):
	if valid:
		$Letter.color = highlightColor
	else:
		$Letter.color = castingColor
	$Letter.update()

func _on_HitArea_input_event(_viewport, event, _shape_idx):
	if event.is_class("InputEventMouseButton"):
		if event.button_index == BUTTON_LEFT && event.pressed:
			emit_signal("casting_started", self)

func _on_HitArea_mouse_entered():
	emit_signal("rune_entered", self)
