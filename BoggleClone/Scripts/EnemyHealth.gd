extends Node2D

var curHealth
var maxHealth

func _ready():
	pass
#	for orb in get_children():
#		orb.visible = false

func _on_update_health(enemy):
	print(enemy.curHealth)
	print(enemy.maxHealth)
	# Store new health
	curHealth = enemy.curHealth
	maxHealth = enemy.maxHealth
	
	$HealthBar.max_value = maxHealth
	$HealthBar.value = curHealth
	
	# Hide number of orbs exceeding health
#	for i in range(0, get_children().size()):
#		if i < curHealth:
#			get_children()[i].visible = true
#		else:
#			get_children()[i].visible = false
