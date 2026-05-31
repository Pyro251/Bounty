extends Parallax2D

func _ready() -> void:
	
	var random_color_value: float = randf_range(0.72, 1.0)
	var random_scroll_scale_value: float = randf_range(1.1, 1.7)
	
	scroll_scale = Vector2(random_scroll_scale_value, random_scroll_scale_value)
	
	modulate = Color(random_color_value, random_color_value, random_color_value, 1.0)
