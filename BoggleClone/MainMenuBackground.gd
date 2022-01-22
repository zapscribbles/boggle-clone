extends ParallaxBackground

export var camera_velocity: Vector2 = Vector2( 100, 0 );
export var fadeOut = false

func _process(delta: float) -> void:
	if fadeOut:
#		new_offset.y = get_scroll_offset().y - 5
		camera_velocity.y = -200
	var new_offset: Vector2 = get_scroll_offset() + camera_velocity * delta
	set_scroll_offset( new_offset )
