tool
extends Node2D

var letter = "X"
var glowFont = preload("res://glow-font.tres")
var cellSize

func _draw():
	glowFont.size = 5*13
	var glowSize = Vector2(glowFont.size, glowFont.size*1.225)
	draw_string(glowFont, Vector2((cellSize.x - glowSize.x)/2, -(cellSize.y - glowSize.y)/2), letter, Color.darkcyan)
