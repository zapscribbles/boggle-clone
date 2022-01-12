extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$RuneGrid.connect("spell_updated", self, "_on_spell_updated")
	pass # Replace with function body.

func _on_spell_updated():
	var spell = ""
	for rune in $RuneGrid.spellBeingCast:
		spell += rune.letter
	$SpellLabel.text = spell
