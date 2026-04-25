extends Node2D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _physics_process(delta: float) -> void:
		global_position = get_global_mouse_position()
