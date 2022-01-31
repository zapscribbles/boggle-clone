extends GridContainer

var slotScene = preload("res://OverpowerSlot.tscn")

func _ready():
	for i in range(0, 9):
		var slot = slotScene.instance()
		add_child(slot)
