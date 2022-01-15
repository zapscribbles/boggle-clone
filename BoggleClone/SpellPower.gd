extends Node2D

var firstOrbPos
var distanceBetweenOrbs

func _ready():
	# Get first orb position from where it was placed in the editor
	firstOrbPos = $SpellPowerOrb.position
	# Get initial distance between orbs from the editor
	distanceBetweenOrbs = firstOrbPos.distance_to($SpellPowerOrb2.position)
	# Delete initial orbs - they were only placed for spacing/sizing purposes
	$SpellPowerOrb.queue_free()
	$SpellPowerOrb2.queue_free()
	
func _on_spell_updated(spellAsRunes, spellAsString):
	# NB This signal is connected in the Game script
	print("spell power is ", spellAsRunes.size())
	
	if spellAsRunes.size() <= 0:
		for orb in get_children():
			orb.queue_free()
	else:
		# Add the first orb if there isnt one
		if get_child_count() == 0:
			add_orb(firstOrbPos)
		# Add additional orbs if there aren't already enough
		elif get_child_count() < spellAsRunes.size():
			for i in range(1, spellAsRunes.size() - get_child_count() + 1):
				add_orb()
		elif get_child_count() > spellAsRunes.size():
			for i in range(1, get_child_count() - spellAsRunes.size() + 1):
				remove_last_orb()

func add_orb(position = null):
	if position == null:
		position = get_children().back().position + Vector2(distanceBetweenOrbs,0)
	var orb = load("res://SpellPowerOrb.tscn").instance()
	orb.position = position
	add_child(orb)

func remove_last_orb():
	get_children().back().queue_free()
