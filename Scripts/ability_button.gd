extends TextureButton

var texture: Texture

@export var hover_scale: Vector2 = Vector2(1.1, 1.1)
@export var pressed_scale: Vector2 = Vector2(0.9, 0.9)
@export var main_ability: bool = false
@export var secondary_ability: bool = false
@export var ability: String
@export_multiline var ability_button_text: String

func _ready() -> void:
	Global.update_ability_button_texture.connect(update_texture)

func _on_mouse_entered() -> void:
	
	if main_ability:
		Global.main_ability_description = ability_button_text
	if secondary_ability:
		Global.secondary_ability_description = ability_button_text
	Global.update_ability_description.emit()
	create_tween().tween_property(self, "scale", hover_scale, 0.1).set_trans(Tween.TRANS_SINE)

func update_texture():
	texture_normal = texture
	texture_pressed = texture
	texture_hover = texture
	texture_disabled = texture
	texture_focused = texture

func _on_mouse_exited() -> void:
	create_tween().tween_property(self, "scale", Vector2.ONE, 0.1).set_trans(Tween.TRANS_SINE)


func _on_pressed() -> void:
	
	
	# sets only one to be true
	if main_ability:
		Global.main_ability_selected_var = true
		Global.main_ability_selected.emit()
		for i in range(Global.abilities_nested.main.selected.size()):
			Global.abilities_nested.main.selected[i] = false
		
		Global.abilities_nested.main.selected.set(ability, true)
	elif secondary_ability:
		Global.secondary_ability_selected_var = true
		Global.secondary_ability_selected.emit()
		for i in range(Global.abilities_nested.secondary.selected.size()):
			Global.abilities_nested.secondary.selected[i] = false
		
		Global.abilities_nested.secondary.selected.set(ability, true)
