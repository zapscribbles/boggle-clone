extends Node2D

signal update_enemy_health(_health)
signal enemy_killed

export(String, "Creature") var enemyType = "Creature"

var health

func _init():
	visible = false

# Called when the node enters the scene tree for the first time.
func _ready():
	# Load enemy definitions
	var file = File.new()
	file.open("res://enemy_defs.json", file.READ)
	var json = file.get_as_text()
	var enemyDefs = JSON.parse(json).result
	file.close()
	
	# Set parameters based on definition
	health = enemyDefs[enemyType].health
	emit_signal("update_enemy_health", health)
	$AnimationPlayer.play("entrance")
	visible = true

func _on_enemy_hit(byOrb):
	print("im taking damage!")
	$Sprites/Creature.play("hit")
	$HitEffect.emitting = true
	health = health - 1
	emit_signal("update_enemy_health", health)
	if health <= 0:
		$Sprites/Creature.play("death")
		$AnimationPlayer.play("exit")

func _on_animation_finished():
	if $Sprites/Creature.animation == "hit":
		$Sprites/Creature.play("idle")
	if $Sprites/Creature.animation == "death":
		emit_signal("enemy_killed")
