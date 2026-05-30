extends Node2D

@export var enemies: int = 0
@export var boss_level: bool = false

func _ready() -> void:
	
	Global.can_clear_level = true
	Global.enemies_killed = 0
	Global.money_made_this_level = 0
	
	
	Global.enemies_in_current_level = enemies
	
	if boss_level:
		Global.in_boss_level = true
	
	
	Global.can_clear_level = true
