extends Control


@onready var money: Label = $Money

func _process(delta: float) -> void:
	money.text = str("MONEY: ", Global.player_money)

func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/base.tscn")
