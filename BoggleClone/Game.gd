extends Node2D

var spell

func _ready():
	$RuneGrid.connect("spell_updated", self, "_on_spell_updated")
	$RuneGrid.connect("spell_updated", $SpellPower, "_on_spell_updated")
	$RuneGrid.connect("spell_cast", self, "_on_spell_cast")
	pass # Replace with function body.

func _on_spell_updated(spellAsRunes, spellAsString):
	
	spell = spellAsString
		
	# Update label
	$SpellLabel.text = spell

func _on_spell_cast():
	
	# Check if spell is valid - if it is, cast it
	if check_spell_validity():
		print("spell was valid")
		# Shoot energy at enemy
		# Damage enemy (Check enemy health - spawn another if dead)
	else:
		print("spell was invalid")

	
func check_spell_validity():
	# Put dictionary check here - just checking for letter length for now
	if spell.length() >= 3:
		return true
