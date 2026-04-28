extends TextureButton
class_name SkillNode

@export var max_level: int = 3
@export var levels_to_unlock_next_level: int = 3
@export_multiline var text: String

@onready var panel: Panel = $Panel
@onready var label: Label = $MarginContainer/Label
@onready var line_2d: Line2D = $Line2D
@onready var accept_anim: AnimationPlayer = $AcceptAnim
@onready var reject_anim: AnimationPlayer = $RejectAnim
@onready var reject_sound: AudioStreamPlayer = $RejectSound
@onready var accept_sound: AudioStreamPlayer = $AcceptSound

@onready var text_box: PanelContainer = $TextBox
@onready var text_label: Label = $TextBox/MarginContainer/Text


var level: int = 0:
	set(value):
		level = value
		#label.text = str(level) + "/3"
		label.text = str(level, "/", max_level)

func _ready() -> void:
	text_label.text = text
	
	if get_parent() is SkillNode:
		line_2d.add_point(self.global_position + self.size / 2)
		line_2d.add_point(get_parent().global_position + get_parent().size / 2)

#func _on_pressed() -> void:



func _on_pressed() -> void:

	self.self_modulate = Color(1.0, 1.0, 1.0, 1.0)
	line_2d.default_color = Color(1.0, 1.0, 1.0, 1.0)
	
	# Handels how much it can be upgraded
	var skills = get_children()
	for skill in skills:
		if skill is SkillNode and level == levels_to_unlock_next_level:
			skill.disabled = false
	
	
	# Handels actually giving the player the ability.
	if self.is_in_group("health1"):
		if Global.player_money >= 100:
			Global.max_player_health += 10.0
			Global.player_money -= 100
			accept()
		else:
			reject()


func accept():
	accept_anim.play("Accept")
	level = min(level + 1, max_level)

func reject():
	reject_sound.play()
	reject_anim.play("Reject")

func _on_mouse_entered() -> void:
	text_box.show()


func _on_mouse_exited() -> void:
	text_box.hide()
