extends Control

@onready var money_made_label: Label = $MoneyMade

func _physics_process(delta: float) -> void:
	money_made_label.text = str("Money Made: ", Global.money_made_this_level, "$")

func _on_play_pressed() -> void:
	Global.ammo = 20
	get_tree().change_scene_to_file("res://Scenes/Levels/base.tscn")
	Global.current_level += 1
