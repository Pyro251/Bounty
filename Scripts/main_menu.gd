extends Control

@onready var blip_sound: AudioStreamPlayer = $BlipSound
@onready var click_sound: AudioStreamPlayer = $ButtonClick
@onready var loading = $loading_screen
@onready var options_menu: Control = $OptionsMenu
@onready var change_log: Control = $ChangeLog

func _ready():
	change_log.show()
	options_menu.hide()
	loading.hide()

func _on_play_pressed() -> void:
	loading.show()
	$loading_screen/ProgressBar/AnimationPlayer.play("Fill bar")
	
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
