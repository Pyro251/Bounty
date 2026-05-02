extends RichTextLabel

@export var hover_scale: Vector2 = Vector2(1.1, 1.1)
@export var pressed_scale: Vector2 = Vector2(0.9, 0.9)

func _ready() -> void:
	mouse_entered.connect(_button_enter)
	mouse_exited.connect(_button_exit)
	#pressed.connect(_button_pressed)
	
	call_deferred("_init_pivot")


func _init_pivot() -> void:
	pivot_offset = size / 2.0


func _button_enter() -> void:
	create_tween().tween_property(self, "scale", hover_scale, 0.1).set_trans(Tween.TRANS_SINE)

func _button_exit() -> void:
	create_tween().tween_property(self, "scale", Vector2.ONE, 0.1).set_trans(Tween.TRANS_SINE)

#func _button_pressed() -> void:
	#pass
