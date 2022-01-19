extends Path2D

func _ready():
	# Get the initial control point as a basis for randomising
	var cp = curve.get_point_in(1)
	# Randomise the y value of the control point
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	cp.y = rng.randf_range(cp.y, cp.y*-1)
	# Set the new control point
	curve.set_point_in(1, cp)

func _draw():
	draw_polyline(curve.get_baked_points(), Color.aquamarine, 1, true)


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "store_in_chest":
#		queue_free()
		print("coin stored")
