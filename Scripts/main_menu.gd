extends Control

@onready var blip_sound: AudioStreamPlayer = $BlipSound
@onready var click_sound: AudioStreamPlayer = $ButtonClick
@onready var loading = $loading_screen
@onready var options_menu: Control = $OptionsMenu
@onready var change_log: Control = $ChangeLog
@onready var load_game_button: Button = $VBoxContainer/LoadGame

func _ready():
	if Global.show_changes:
		change_log.show()
	else:
		change_log.hide()
	options_menu.hide()
	loading.hide()

func _physics_process(delta: float) -> void:
	if FileAccess.file_exists(SaveLoad.SAVE_LOCATION):
		load_game_button.disabled = false
	else:
		load_game_button.disabled = true


func _on_play_pressed() -> void:
	loading.show()
	$loading_screen/ProgressBar/AnimationPlayer.play("Fill bar")
	SaveLoad._wipe_save()
	click_sound.play()
	


func _on_loading_screen_loaded():
	Global.ammo += 20
	get_tree().change_scene_to_file("res://Scenes/Levels/base.tscn")


func _on_play_mouse_entered():
	$Blip.play()


func _on_options_mouse_entered():
	$Blip.play()


func _on_quit_mouse_entered():
	$Blip.play()


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_options_pressed() -> void:
	options_menu.show()
	click_sound.play()


func _on_load_game_pressed() -> void:
	loading.show()
	$loading_screen/ProgressBar/AnimationPlayer.play("Fill bar")
	SaveLoad._load()
	SaveLoad._set_load_data()
