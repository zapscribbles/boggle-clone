extends Node2D

var cellDice = ['AAEEGN' , 'ELRTTY' , 'AOOTTW' , 'ABBJOO' , 'EHRTVW' , 'CIMOTU' , 'DISTTY' , 'EIOSST' , 'DELRVY' , 'ACHOPS' , 'QQQQQQ' , 'EEINSU' , 'EEGHNW' , 'AFFKPS' , 'HLNNRZ' , 'DEILRX']
#HIMNQU
enum {NOT_CASTING, CASTING_STARTED, SPELL_COMPLETED}
var castingState = NOT_CASTING
var castingLine
var spellBeingCast = []

signal spell_updated
signal spell_cast

# Called when the node enters the scene tree for the first time.
func _ready():
	
	castingLine = get_parent().get_node("CastingLine")
	
	generate_grid()

func generate_grid():
	# Roll each dice to get a single letter
	var letters = []
	var rng = RandomNumberGenerator.new()
	for die in cellDice:
		rng.randomize()
		var position = rng.randi_range(0, 5)
		var chosenLetter = die[position]
		if chosenLetter == "Q":
			chosenLetter = "Qu"
		letters.append(chosenLetter)
	
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
		var rune = load("res://Scenes/Rune.tscn").instance()
		print("i=",i)
		
		rune.col = i%4
		rune.row = floor(i/4.0)
		print(rune.col, ",", rune.row, " - ", letters[i])
		
		# Set letter
		rune.letter = letters[i]
#		rune.letter = str(col) + "," + str(row)
		rune.position = runeStartPos + Vector2(runeSize * rune.col, runeSize * rune.row)
		add_child(rune, true)
		rune.connect("casting_started", self, "_on_casting_started")
		rune.connect("rune_entered", self, "_on_rune_entered")

func add_rune_to_spell(rune):
	spellBeingCast.append(rune)
	rune.beingCast()
	spell_updated()

func remove_last_rune_from_spell():
	var rune = spellBeingCast.pop_back()
	rune.castingStopped()
	spell_updated()

func spell_updated():
	var spellString = ""
	for rune in spellBeingCast:
		spellString += rune.letter
	emit_signal("spell_updated", spellBeingCast, spellString)

func highlight_runes_if_valid(valid):
	for rune in spellBeingCast:
		rune.set_highlight(valid)

func _on_casting_started(rune):
	if castingState == NOT_CASTING:
		print("Casting started at ", rune.letter)
		castingState = CASTING_STARTED
		castingLine.add_point(rune.position + rune.centre)
		add_rune_to_spell(rune)

func _on_rune_entered(rune):
	if castingState == CASTING_STARTED:
		if not rune.hasBeenCast && is_neighbour(rune):
			print("Casting continues at letter ", rune.letter)
			castingLine.add_point(rune.position + rune.centre)
			add_rune_to_spell(rune)
		elif rune.hasBeenCast && spellBeingCast.back() == rune:
			print("Letter ",rune.letter," removed from spell")
			castingLine.remove_point(spellBeingCast.size()-1) # Minus two here because last point is connected to pointer
			remove_last_rune_from_spell()
			if spellBeingCast.empty():
				castingState = NOT_CASTING

func _on_CastSpell_input_event(viewport, event, shape_idx):
	if (event.is_class("InputEventMouseButton") && 
	event.button_index == BUTTON_RIGHT && 
	event.pressed && 
	castingState == CASTING_STARTED) || (event.is_class("InputEventScreenTouch") && !event.pressed):
		print("spell cast attempted")
		castingState = SPELL_COMPLETED
		castingLine.clear_points()
		emit_signal("spell_cast")
		castingState = NOT_CASTING
		for rune in spellBeingCast:
			rune.castingStopped()
		spellBeingCast = []
		spell_updated()

func is_neighbour(rune):
	# Check if rune is a neighbour of the last rune to be cast
	var origin = spellBeingCast.back()
	# Up
	if rune.row == origin.row-1:
		if rune.col == origin.col-1 || rune.col == origin.col || rune.col == origin.col+1:
			return true
		else:
			return false
	# Down
	elif rune.row == origin.row+1:
		if rune.col == origin.col-1 || rune.col == origin.col || rune.col == origin.col+1:
			return true
		else:
			return false
	# Left or Right
	elif origin.row == rune.row:
		if rune.col == origin.col-1 || rune.col == origin.col+1:
			return true
		else:
			return false
	else:
		return false


