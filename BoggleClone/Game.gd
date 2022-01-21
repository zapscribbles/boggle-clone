extends Node2D

var spell
var enemyPos
#var coinScene = preload("res://Coin.tscn")

func _ready():
	$RuneGrid.connect("spell_updated", self, "_on_spell_updated")
	$RuneGrid.connect("spell_updated", $SpellPower, "_on_spell_updated")
	$RuneGrid.connect("spell_cast", self, "_on_spell_cast")
	$RuneGrid.connect("spell_cast", $SpellPower, "_on_spell_cast")
	enemyPos = $Enemy.position
	spawn_enemy($Enemy)
	$Coin.queue_free() # Only dispaying coin in the editor

func spawn_enemy(enemy = null):
	if enemy == null:
		enemy = load("res://Enemy.tscn").instance()
		add_child(enemy)
	enemy.position = enemyPos
	enemy.connect("update_enemy_health", $EnemyHealth, "_on_update_health") 
	enemy.connect("enemy_dead", self, "_on_enemy_dead")
	enemy.connect("enemy_dealt_killing_blow", self, "_on_enemy_dealt_killing_blow")
	$EnemyHealth._on_update_health(enemy.health)

func _on_spell_updated(spellAsRunes, spellAsString):
#	print("game - spell updated")
	spell = spellAsString
		
	# Update label
	$SpellLabel.text = spell

func _on_spell_cast():
	# Check if spell is valid - if it is, cast it
	if check_spell_validity():
#		print("spell was valid")
		# Shoot energy at enemy
		# Damage enemy (Check enemy health - spawn another if dead)
		pass
	else:
#		print("spell was invalid")
		pass

func check_spell_validity():
	# Put dictionary check here - just checking for letter length for now
	if spell.length() >= 3:
		return true

func _on_enemy_dead():
	get_tree().call_group("enemy", "queue_free")
	spawn_enemy()
	
func _on_enemy_dealt_killing_blow(enemy):
	# Open chest
	$Chest.play("open")
	# Generate coins
	var interval = 0.1
	for i in range(0, enemy.value):
		# Prepare timer
		var timer = get_tree().create_timer(interval * i)
		timer.connect("timeout", self, "_on_coin_generation_timeout", [true if i+1 == enemy.value else false])

func _on_coin_generation_timeout(last):
	var coin = load("res://Coin.tscn").instance()
	coin.position = enemyPos
	coin.last = last
	coin.connect("last_coin_stored", self, "_on_last_coin_stored")
	add_child(coin)

func _on_last_coin_stored():
	$Chest.play("close")
