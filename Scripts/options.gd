extends Control

@onready var click_sound: AudioStreamPlayer = $Click

func _ready() -> void:
	hide()



func _on_done_pressed() -> void:
	click_sound.play()
	hide()
