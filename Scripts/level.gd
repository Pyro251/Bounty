extends Node2D

func _ready() -> void:
	if self.is_in_group("level1"):
		Global.enemies_in_current_level = 3
	Global.can_clear_level = true
