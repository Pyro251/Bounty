extends Control


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/base.tscn")
	Global.current_level += 1
