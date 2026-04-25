extends TextureButton
#class_name SkillNode

@export var max_level: int = 3

@onready var panel: Panel = $Panel
@onready var label: Label = $MarginContainer/Label

var level: int = 0:
	set(value):
		level = value
		label.text = str(level) + "/3"




#@onready var skill_level: Label = $SkillLevel
#@onready var skill_branch: Line2D = $SkillBranch
#

#
#var level: int = 0:
	#set(value):
		#level = value
		#skill_level.text = str(level, "/", max_level)
#
#func _ready() -> void:
	#if get_parent() is SkillNode:
		#skill_branch.add_point(self.global_position + self.size / 2)
		#skill_branch.add_point(get_parent().global_position + get_parent().size / 2)
#
#func _on_pressed() -> void:



func _on_pressed() -> void:
	level = min(level + 1, max_level)
	#panel.show_behind_parent = true
	self.self_modulate = Color(1.0, 1.0, 1.0, 1.0)
