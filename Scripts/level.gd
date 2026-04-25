extends Node2D

func _ready() -> void:
	
	Global.can_clear_level = true
	Global.enemies_killed = 0
	
	
	match Global.current_level:
		1:
			Global.enemies_in_current_level = 3
			print("(level 1) ENEMIES_IN_CURRENT_LEVEL SET TO: ", Global.enemies_in_current_level)
		2:
			Global.enemies_in_current_level = 12
			print("(level 2) ENEMIES_IN_CURRENT_LEVEL SET TO: ", Global.enemies_in_current_level)
	
	Global.can_clear_level = true
