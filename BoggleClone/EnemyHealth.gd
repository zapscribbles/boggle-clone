extends Node2D

var health

func _ready():
	for orb in get_children():
		orb.visible = false

func _on_update_health(_health):
	# Store new health
	health = _health
	
	# Hide number of orbs exceeding health
	for i in range(0, get_children().size()):
		if i < health:
			get_children()[i].visible = true
		else:
			get_children()[i].visible = false
