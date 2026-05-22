extends Control

@onready var button_click: AudioStreamPlayer = $ButtonClick


func _on_done_pressed() -> void:
	button_click.play()
	Global.show_changes = false
	hide()


func _on_done_mouse_entered() -> void:
	$Blip.play()
