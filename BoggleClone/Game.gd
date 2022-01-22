extends Node2D

var spellAsString
var spellAsRunes
var enemyPos
#var coinScene = preload("res://Coin.tscn")
var dictionary
#var alphabet = {'A' : 0, 'B' : 1,'C' : 2,'D' : 3,'E' : 4,'F' : 5,'G' : 6,'H' : 7,'I' : 8,'J' : 9,'K' : 10,'L' : 11,'M' : 12,'N' : 13,'O' : 14,'P' : 15,'Q' : 16,'R' : 17,'S' : 18,'T' : 19,'U' : 20,'V' : 21,'W' : 22,'X' : 23,'Y' : 24,'Z' : 25 }
var alreadyCast = []

var coins = 0

func _ready():
	# Load dictionary
	var file = File.new()
	file.open("res://dictionary.json", file.READ)
	var json = file.get_as_text()
	dictionary = JSON.parse(json).result
	file.close()
	
	$RuneGrid.connect("spell_updated", self, "_on_spell_updated", [], CONNECT_DEFERRED) # Using CONNECT_DEFERRED here so the spellpwoer node is updated first (orbs added) before we check orb validity here
	$RuneGrid.connect("spell_updated", $SpellPower, "_on_spell_updated")
	$RuneGrid.connect("spell_cast", self, "_on_spell_cast")
	enemyPos = $Enemy.position
	spawn_enemy($Enemy)
	$Coin.queue_free() # Only displaying coin in the editor
	print("test")
	$Chest/Label.text = str(coins)

func spawn_enemy(enemy = null):
	if enemy == null:
		enemy = load("res://Enemy.tscn").instance()
		add_child(enemy)
	enemy.position = enemyPos
	enemy.connect("update_enemy_health", $EnemyHealth, "_on_update_health") 
	enemy.connect("enemy_dead", self, "_on_enemy_dead")
	enemy.connect("enemy_dealt_killing_blow", self, "_on_enemy_dealt_killing_blow")
	$EnemyHealth._on_update_health(enemy.health)
	print("enemy spawned")

func _on_spell_updated(_spellAsRunes, _spellAsString):
#	print("game - spell updated")
	spellAsString = _spellAsString
	spellAsRunes = _spellAsRunes
		
	# Update label
	$SpellLabel.text = spellAsString
	# Enable orbs if spell is valid
	$SpellPower.enable_orbs_if_valid(check_spell_validity())
	# Update definition label
	$DefinitionLabel.text = get_spell_word_definition() if check_spell_validity() else ""

func _on_spell_cast():
	# Check if spell is valid - if it is, cast it
	if check_spell_validity():
		print("spell was valid")
		print("-\nDefinition of ",spellAsString,":\n",get_spell_word_definition(),"\n-")
		alreadyCast.append(spellAsString)
		$SpellPower.cast_spell()
	else:
		print("spell was invalid")

func check_spell_validity():
	if spellAsRunes.size() >= 3 && ! alreadyCast.has(spellAsString):
		var valid = dictionary[spellAsRunes[0].letter].has(spellAsString)
		return valid
	else: 
		return false

func get_spell_word_definition():
	return dictionary[spellAsRunes[0].letter][spellAsString]

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
	coin.connect("coin_stored", self, "_on_coin_stored")
	add_child(coin)

func _on_coin_stored():
	coins = coins + 1
	$Chest/Label.text = str(coins)

func _on_last_coin_stored():
	$Chest.play("close")
