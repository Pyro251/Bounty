extends Button

@export var save_name: String
@export_multiline var label_text: String

@export var hover_scale: Vector2 = Vector2(1.1, 1.1)
@export var pressed_scale: Vector2 = Vector2(0.9, 0.9)

func _ready() -> void:
	
	if Global.tooltips.get(save_name):
		show()
	else:
		hide()
	
	if !Global.tooltips.has(save_name):
		Global.tooltips[save_name] = true
		show()
	
	$RichTextLabel.text = label_text


func _on_pressed() -> void:
	Global.tooltips.set(save_name, false)
	hide()


func _on_mouse_entered() -> void:
	create_tween().tween_property(self, "scale", hover_scale, 0.1).set_trans(Tween.TRANS_SINE)


func _on_mouse_exited() -> void:
	create_tween().tween_property(self, "scale", Vector2.ONE, 0.1).set_trans(Tween.TRANS_SINE)
