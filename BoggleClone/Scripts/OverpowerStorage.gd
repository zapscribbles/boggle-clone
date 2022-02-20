extends Node2D

var nextSpawn = 1

func _ready():
#	print($SpellPowerOrb.position)
#	print(to_local($SpellPowerOrb.position))
#	print(to_global($SpellPowerOrb.position))
	pass
	
func store(orb:RigidBody2D):
	orb.get_parent().remove_child(orb)
	add_child(orb)
	var spawnName = "SpawnPoint" + str(nextSpawn)
	orb.position = get_node(spawnName).position
	orb.sleeping = false
	nextSpawn = 1 if nextSpawn == 3 else nextSpawn + 1
	
	

