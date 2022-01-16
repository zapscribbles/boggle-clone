extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_enemy_hit(byOrb):
	print("im taking damage!")
	$Sprites/Creature.play("hit")
	$HitEffect.emitting = true

func _on_animation_finished():
	if $Sprites/Creature.animation == "hit":
		$Sprites/Creature.play("idle")
