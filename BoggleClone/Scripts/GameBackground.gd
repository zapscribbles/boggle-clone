extends ParallaxBackground

export var camera_velocity: Vector2 = Vector2( 0, 0 );
export var fadeIn = true

func _process(delta: float) -> void:
	if !fadeIn:
		camera_velocity.y = 0
	var new_offset: Vector2 = get_scroll_offset() + camera_velocity * delta
	if new_offset.y <= 0:
		new_offset.y = 0
		fadeIn = false
	set_scroll_offset( new_offset )
