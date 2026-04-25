extends Node2D

func _ready() -> void:
	
	Global.can_clear_level = true
	Global.enemies_killed = 0
	
	if self.is_in_group("level1"):
		Global.enemies_in_current_level = 3
	if self.is_in_group("level2"):
		Global.enemies_in_current_level = 13
	Global.can_clear_level = true
