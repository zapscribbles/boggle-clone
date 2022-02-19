extends RigidBody2D

export var debug := false
var enabled = false
var shooting = false

signal enemy_hit(byOrb)

func _ready():
	# Show the appropriate sprite
	check_enabled()
	sleeping = true

func check_enabled():
	if enabled:
		$Path2D/PathFollow2D/Enabled.visible = true
		$Path2D/PathFollow2D/Disabled.visible = false
	else:
		$Path2D/PathFollow2D/Enabled.visible = false
		$Path2D/PathFollow2D/Disabled.visible = true

func set_enabled(setting):
	if !shooting:
		enabled = setting
		check_enabled()

func _draw():
	if debug:
		$Path2D.draw_polyline($Path2D.curve.get_baked_points(), Color.aquamarine, 1, true)

func _process(delta):
	if shooting:
		$Path2D/PathFollow2D.unit_offset += delta*5
		if $Path2D/PathFollow2D.unit_offset >= 1:
			emit_signal("enemy_hit", self)
			shooting = false
			$Path2D/PathFollow2D.unit_offset = 0
			$Path2D/PathFollow2D.position = Vector2(0,0)

func shoot():
	shooting = true
	# Prep path for shooting at enemy
	var localPos = to_local(position)
	var enemyLocalPos = to_local(get_node("/root/Game/").enemyPos)
	var dest = enemyLocalPos - localPos
	$Path2D.curve.add_point(localPos)
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var cpX = rng.randf_range(-60, 60)
	rng.randomize()
	var cpY = rng.randf_range(-60, 60)
	$Path2D.curve.add_point(dest, Vector2(cpX, cpY))
	_draw()


func _on_Timer_timeout():
	if !sleeping:
		var rnd = RandomNumberGenerator.new()
		rnd.randomize()
		var xForce = rnd.randf_range(-500, 500)
		var yForce = rnd.randf_range(-500, 500)
		applied_force = Vector2(xForce, yForce)
