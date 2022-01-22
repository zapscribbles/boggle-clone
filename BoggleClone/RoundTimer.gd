extends Timer

func _ready():
	pass # Replace with function body.

func _process(delta):
	$Labels/Minutes.text = str(floor(time_left / 60.0))
	$Labels/Seconds.text = str(floor(fmod(time_left, 60.0)))
	if time_left <= 10 && !$Labels/AnimationPlayer.is_playing():
		$Labels/AnimationPlayer.play("almost_timeout")

#func get_pretty_time_left():
#	var pretty = ""
#	pretty = pretty + str(floor(time_left / 60.0)) + "m "
#	pretty = pretty + str(floor(fmod(time_left, 60.0))) + "s"
#	return pretty
