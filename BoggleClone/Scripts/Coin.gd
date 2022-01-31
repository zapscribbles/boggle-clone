extends Path2D

var last

signal last_coin_stored
signal coin_stored

func _ready():
	# Get the initial control point as a basis for randomising
	var cp = curve.get_point_in(1)
	# Randomise the y value of the control point
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	cp.y = rng.randf_range(30, -30)
	# Set the new control point
	curve.set_point_in(1, cp)
	# Kick off animation
	$AnimationPlayer.play("store_in_chest")

func _draw():
	pass
#	draw_polyline(curve.get_baked_points(), Color.aquamarine, 1, true)

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "store_in_chest":
#		print(name," coin stored")
		emit_signal("coin_stored")
		if last:
			emit_signal("last_coin_stored")
		queue_free()
