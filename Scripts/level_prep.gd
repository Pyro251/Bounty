extends Control

@onready var start_level_button: Button = $StartLevel
@onready var close_ready_prep_sound: AudioStreamPlayer = $CloseReadyPrepSound


func _physics_process(delta: float) -> void:
	
	start_level_button.text = str("START LEVEL ", Global.current_level, "?")

func _on_play_pressed() -> void:
	Global.at_base = false
	get_tree().change_scene_to_file(Global.level_to_load)


func _on_cancel_pressed() -> void:
	close_ready_prep_sound.play()
	Global.close_run_settings.emit()
	Global.show_player_ui.emit()
	print("loading:", Global.level_to_load)
	print("Current Level: ", Global.current_level)
	Global.in_menu = false
	Global.at_base = false
