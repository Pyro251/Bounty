extends Control

@onready var blip_sound: AudioStreamPlayer = $BlipSound
@onready var click_sound: AudioStreamPlayer = $ButtonClick
@onready var loading = $loading_screen

func _ready():
	loading.hide()

func _on_play_pressed() -> void:
	loading.show()
	$loading_screen/ProgressBar/AnimationPlayer.play("Fill bar")
	$Blip
	click_sound.play()
	




func _on_loading_screen_loaded():
	get_tree().change_scene_to_file("res://Scenes/Levels/base.tscn")
