extends Path2D

export var debug := false
var enabled = false
var shooting = false

signal enemy_hit(byOrb)

func _ready():
	# Show the appropriate sprite
	check_enabled()

func check_enabled():
	if enabled:
		$PathFollow2D/Enabled.visible = true
		$PathFollow2D/Disabled.visible = false
	else:
		$PathFollow2D/Enabled.visible = false
		$PathFollow2D/Disabled.visible = true

func set_enabled(setting):
	if !shooting:
		enabled = setting
		check_enabled()

func _draw():
	if debug:
		draw_polyline(curve.get_baked_points(), Color.aquamarine, 1, true)

func _process(delta):
	if shooting:
		$PathFollow2D.unit_offset += delta*1.8
		if $PathFollow2D.unit_offset >= 1:
			emit_signal("enemy_hit", self)

func shoot():
	shooting = true
	# Prep path for shooting at enemy
	var localPos = to_local(position)
	var enemyLocalPos = to_local(get_node("/root/Game/").enemyPos)
	var dest = enemyLocalPos - localPos
	curve.add_point(localPos)
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var cpX = rng.randf_range(-60, 60)
	rng.randomize()
	var cpY = rng.randf_range(-60, 60)
	curve.add_point(dest, Vector2(cpX, cpY))
	_draw()
