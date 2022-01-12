tool
extends Node2D

var letter = "X"
var color = Color.cornflower

func _draw():
	var font = load("res://antiquity.tres")
	font.size = 80
	var cellSize = get_parent().get_node("ReferenceRect").rect_size
	var runeSize = Vector2(font.size, font.size*1.225)
	
	draw_string(font, Vector2((cellSize.x - runeSize.x)/2, -(cellSize.y - runeSize.y)/2), letter, color)
