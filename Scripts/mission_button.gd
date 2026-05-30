extends Button

@onready var title_label: Label = $Title

@export var title: String = "type here"
@export_multiline var mission_text = "type here"

@export var level_till_unlock: int = 0
@export var level_till_next_unlock: int = 0
@export var unlocked_from_start: bool = false

@export var hover_scale: Vector2 = Vector2(1.1, 1.1)

func _ready() -> void:
	title_label.text = title
	
	mouse_entered.connect(_button_enter)
	mouse_exited.connect(_button_exit)
	
	if level_till_unlock <= Global.current_level:
		show()
	else:
		if !unlocked_from_start:
			hide()
		else:
			show()
	
	if Global.current_level >= level_till_next_unlock:
		title_label.modulate = Color(0.211, 0.444, 0.2, 1.0)

func _on_pressed() -> void:
	Global.mission_panel_text = mission_text
	Global.mission_selected.emit()
	Global.mission_selected_var = true
	
	if Global.current_level <= level_till_next_unlock:
		title_label.modulate = Color(0.818, 0.648, 0.386, 1.0)

func _button_enter() -> void:
	#blip.play()
	create_tween().tween_property(self, "scale", hover_scale, 0.1).set_trans(Tween.TRANS_SINE)

func _button_exit() -> void:
	create_tween().tween_property(self, "scale", Vector2.ONE, 0.1).set_trans(Tween.TRANS_SINE)
