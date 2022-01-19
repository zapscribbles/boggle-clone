extends Node2D

var spell
var enemyPos

func _ready():
	$RuneGrid.connect("spell_updated", self, "_on_spell_updated")
	$RuneGrid.connect("spell_updated", $SpellPower, "_on_spell_updated")
	$RuneGrid.connect("spell_cast", self, "_on_spell_cast")
	$RuneGrid.connect("spell_cast", $SpellPower, "_on_spell_cast")
	$Enemy.connect("update_enemy_health", $EnemyHealth, "_on_update_health") 
	$EnemyHealth._on_update_health($Enemy.health) # Need to do this the first time the game loads as emitting the signal on first Enemy load doesn't work (signal wasn;t connected yet as Game wasn;t _ready to connect signals
	$Enemy.connect("enemy_killed", self, "_on_enemy_killed")
	enemyPos = $Enemy.position
	$Coin.queue_free() # Only dispaying coin in the editor

func _on_spell_updated(spellAsRunes, spellAsString):
	print("game - spell updated")
	spell = spellAsString
		
	# Update label
	$SpellLabel.text = spell

func _on_spell_cast():
	# Check if spell is valid - if it is, cast it
	if check_spell_validity():
		print("spell was valid")
		# Shoot energy at enemy
		# Damage enemy (Check enemy health - spawn another if dead)
	else:
		print("spell was invalid")

func check_spell_validity():
	# Put dictionary check here - just checking for letter length for now
	if spell.length() >= 3:
		return true

func _on_enemy_killed():
	get_tree().call_group("enemy", "queue_free")
	var newEnemy = load("res://Enemy.tscn").instance()
	newEnemy.position = enemyPos
	newEnemy.connect("update_enemy_health", $EnemyHealth, "_on_update_health") 
	newEnemy.connect("enemy_killed", self, "_on_enemy_killed")
	add_child(newEnemy)
	for i in range(0, 5):
		var coin = load("res://Coin.tscn").instance()
		coin.position = enemyPos
		add_child(coin)
