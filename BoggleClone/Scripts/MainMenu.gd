extends Control

func _ready():
	pass # Replace with function body.


func _on_StartButton_button_up():
	$AnimationPlayer.play("fade_out")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "fade_out":
		get_tree().change_scene("res://Scenes/Game.tscn")
