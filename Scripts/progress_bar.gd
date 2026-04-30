extends Control


@onready var money: Label = $Money

func _process(delta: float) -> void:
	money.text = str("MONEY: ", Global.player_money)

func _on_quit_pressed() -> void:
	save()
	get_tree().change_scene_to_file("res://Scenes/Levels/base.tscn")

func save():
	SaveLoad._set_save_data()
	SaveLoad._save()
