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
#	print("spell power is ", spellAsRunes.size())
	
	var numStaticOrbs = get_static_orbs()
	
	if spellAsRunes.size() <= 0:
		for orb in get_children():
			if !orb.shooting:
				orb.queue_free()
	else:
		# Add the first orb if there isnt one
		if numStaticOrbs == 0:
			add_orb(firstOrbPos)
		# Add additional orbs if there aren't already enough
		elif numStaticOrbs < spellAsRunes.size():
			for i in range(1, spellAsRunes.size() - numStaticOrbs + 1):
				add_orb()
		# Remove them if there are too many (and they aren;t currently being shot by a previous cast
		elif numStaticOrbs > spellAsRunes.size():
			for i in range(1, numStaticOrbs - spellAsRunes.size() + 1):
				remove_last_orb()

func enable_orbs_if_valid(valid):
	# Enable all orbs if spell is valid - or disable if invalid
	if valid:
		for orb in get_children():
			orb.set_enabled(true)
	else:
		for orb in get_children():
			orb.set_enabled(false)

func get_static_orbs():
	# Get number of orbs that aren't currently shooting
	var count = 0
	for orb in get_children():
		if !orb.shooting:
			count += 1
	return count

func cast_spell():
	# Game calls this if the spell is valid
	for orb in get_children():
		orb.shoot()

func add_orb(position = null):
	if position == null:
		position = get_children().back().position + Vector2(distanceBetweenOrbs,0)
	var orb = load("res://Scenes/SpellPowerOrb.tscn").instance()
	orb.position = position
	add_child(orb)
	orb.connect("enemy_hit", get_tree().get_nodes_in_group("enemy")[0], "_on_enemy_hit")

func remove_last_orb():
	get_children().back().queue_free()
