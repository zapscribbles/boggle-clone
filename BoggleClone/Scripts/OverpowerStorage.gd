extends GridContainer

var slotScene = preload("res://Scenes/OverpowerSlot.tscn")

func _ready():
	for i in range(0, 9):
		var slot = slotScene.instance()
		add_child(slot)
