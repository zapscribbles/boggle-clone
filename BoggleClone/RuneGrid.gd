extends Node2D

var cellDice = ['AAEEGN' , 'ELRTTY' , 'AOOTTW' , 'ABBJOO' , 'EHRTVW' , 'CIMOTU' , 'DISTTY' , 'EIOSST' , 'DELRVY' , 'ACHOPS' , 'HIMNQU' , 'EEINSU' , 'EEGHNW' , 'AFFKPS' , 'HLNNRZ' , 'DEILRX']

enum {NOT_CASTING, CASTING_STARTED, SPELL_COMPLETED}
var castingState = NOT_CASTING
var castingLine
var spellBeingCast = []

signal spell_updated

# Called when the node enters the scene tree for the first time.
func _ready():
	
	castingLine = get_parent().get_node("CastingLine")
	
	generate_grid()
	
	pass # Replace with function body.

func generate_grid():
	# Roll each dice to get a single letter
	var letters = []
	var rng = RandomNumberGenerator.new()
	for die in cellDice:
		rng.randomize()
		var position = rng.randi_range(0, 5)
		letters.append(die[position])
	
	# Shuffle the order of letters
	randomize()
	letters.shuffle()
	print(letters)
	
	# Populate grid
	# RuneStart is used to get the starting position of the grid, plus some other info abotu the runes (size etc)
	var runeStartNode = $RuneStart
	var runeStartPos = runeStartNode.position
	var runeSize = runeStartNode.get_node("ReferenceRect").rect_size.x
	remove_child(runeStartNode)
	
	for i in range(0, letters.size()):
		var rune = load("res://Rune.tscn").instance()
		print("i=",i)
		
		var col = i%4
		var row = floor(i/4.0)
		print(col, ",", row, " - ", letters[i])
		
		# Set letter
		rune.letter = letters[i]
#		rune.letter = str(col) + "," + str(row)
		rune.position = runeStartPos + Vector2(runeSize * col, runeSize * row )
		add_child(rune, true)
		rune.connect("casting_started", self, "_on_casting_started")
		rune.connect("rune_entered", self, "_on_rune_entered")

func add_rune_to_spell(rune):
	spellBeingCast.append(rune)
	rune.beingCast()
	emit_signal("spell_updated")

func remove_last_rune_from_spell():
	var rune = spellBeingCast.pop_back()
	rune.castingStopped()
	emit_signal("spell_updated")

func cast_spell():
	pass

func _on_casting_started(rune):
	if castingState == NOT_CASTING:
		castingState = CASTING_STARTED
		castingLine.add_point(rune.position + rune.centre)
		add_rune_to_spell(rune)
		print("Casting started at ", rune.letter)

func _on_rune_entered(rune):
	if castingState == CASTING_STARTED:
		if not rune.hasBeenCast:
			castingLine.add_point(rune.position + rune.centre)
			add_rune_to_spell(rune)
			print("Casting continues at letter ", rune.letter)
		elif rune.hasBeenCast && spellBeingCast.back() == rune:
			castingLine.remove_point(spellBeingCast.size()-1) # Minus two here because last point is connected to pointer
			remove_last_rune_from_spell()
			print("Letter ",rune.letter," removed from spell")
			if spellBeingCast.empty():
				castingState = NOT_CASTING

func _on_CastSpell_input_event(viewport, event, shape_idx):
	if (event.is_class("InputEventMouseButton") && 
	event.button_index == BUTTON_RIGHT && 
	event.pressed && 
	castingState == CASTING_STARTED):
		print("spell cast")
		castingState = SPELL_COMPLETED
		castingLine.clear_points()
		cast_spell()
		castingState = NOT_CASTING
		for rune in spellBeingCast:
			rune.castingStopped()
		spellBeingCast = []
		emit_signal("spell_updated")
