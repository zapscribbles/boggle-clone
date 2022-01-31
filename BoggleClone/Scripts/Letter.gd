tool
extends Node2D

var letter = "X"
var color = Color.royalblue
var font = preload("res://Assets/Fonts/rune-font.tres")

func _draw():
	var cellSize = get_parent().get_node("ReferenceRect").rect_size
	$Glow.cellSize = cellSize
	font.size = 5*13
	var runeSize = Vector2(font.size, font.size*1.225)
	draw_string(font, Vector2((cellSize.x - runeSize.x)/2, -(cellSize.y - runeSize.y)/2), letter, color)
	
	$Glow.letter = letter
