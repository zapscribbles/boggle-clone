extends ReferenceRect

var occupied = false

func _ready():
	pass # Replace with function body.

func get_center():
	return Vector2(rect_global_position.x + rect_size.x/2, rect_global_position.y + rect_size.y/2)
