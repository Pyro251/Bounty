extends TextureButton
class_name SkillNode

@export var max_level: int = 3
@export var levels_to_unlock_next_level: int = 3
@export_multiline var text: String

@onready var panel: Panel = $Panel
@onready var label: Label = $MarginContainer/Label
@onready var line_2d: Line2D = $Line2D

@onready var text_box: PanelContainer = $TextBox
@onready var text_label: Label = $TextBox/MarginContainer/Text


var level: int = 0:
	set(value):
		level = value
		#label.text = str(level) + "/3"
		label.text = str(level, "/", max_level)




#@onready var skill_level: Label = $SkillLevel
#@onready var skill_branch: Line2D = $SkillBranch
#

#
#var level: int = 0:
	#set(value):
		#level = value
		#skill_level.text = str(level, "/", max_level)

func _ready() -> void:
	text_label.text = text
	
	if get_parent() is SkillNode:
		line_2d.add_point(self.global_position + self.size / 2)
		line_2d.add_point(get_parent().global_position + get_parent().size / 2)

#func _on_pressed() -> void:



func _on_pressed() -> void:
	level = min(level + 1, max_level)
	self.self_modulate = Color(1.0, 1.0, 1.0, 1.0)
	line_2d.default_color = Color(1.0, 1.0, 1.0, 1.0)
	
	var skills = get_children()
	for skill in skills:
		if skill is SkillNode and level == levels_to_unlock_next_level:
			skill.disabled = false


func _on_mouse_entered() -> void:
	text_box.show()


func _on_mouse_exited() -> void:
	text_box.hide()
