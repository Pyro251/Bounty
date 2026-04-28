extends Control

@onready var start_level_button: Button = $StartLevel
@onready var close_ready_prep_sound: AudioStreamPlayer = $CloseReadyPrepSound
@onready var est_enemies: Label = $MainPanel/VBoxContainer/EstimatedEnemies
@onready var est_difficulty: Label 

const LOADING_SCREEN = preload("res://Scenes/Menus/loading_screen.tscn")


	
func _physics_process(delta: float) -> void:
	#line below doesn't quite work yet, attempting to make the label match enemies in the next level
	est_enemies.text = str("Estimated Enemies:", Global.enemies_in_current_level)
	start_level_button.text = str("START LEVEL ", Global.current_level, "?")

func _on_play_pressed() -> void:
	Global.at_base = false
	Global.load_level.emit()
	get_tree().change_scene_to_file("res://Scenes/Menus/loading_screen.tscn")
	
	
func purchace_ammo():
	if Global.player_money >= 50:
		Global.player_money -= 50
		Global.ammo += 10
		Global.ammo_added.emit()

func _on_cancel_pressed() -> void:
	close_ready_prep_sound.play()
	Global.close_run_settings.emit()
	Global.show_player_ui.emit()
	print("loading:", Global.level_to_load)
	print("Current Level: ", Global.current_level)
	Global.in_menu = false
	Global.at_base = false


func _on_purchase_ammo_pressed() -> void:
	purchace_ammo()
