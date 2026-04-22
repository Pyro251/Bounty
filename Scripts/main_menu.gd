extends Control

@onready var play_button_sound: AudioStreamPlayer = $PlayButtonSound
@onready var blip_sound: AudioStreamPlayer = $BlipSound


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menus/between_levels.tscn")
	play_button_sound.play()



func _on_play_mouse_entered() -> void:
	blip_sound.play()


func _on_options_mouse_entered() -> void:
	blip_sound.play()


func _on_quit_mouse_entered() -> void:
	blip_sound.play()
