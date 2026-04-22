extends TextureButton
class_name SkillNode


@onready var skill_level: Label = $SkillLevel
@onready var skill_branch: Line2D = $SkillBranch

@export var max_level: int = 3

var level: int = 0:
	set(value):
		level = value
		skill_level.text = str(level, "/", max_level)

func _ready() -> void:
	if get_parent() is SkillNode:
		skill_branch.add_point(self.global_position + self.size / 2)
		skill_branch.add_point(get_parent().global_position + get_parent().size / 2)

func _on_pressed() -> void:
	level = min(level + 1, max_level)
	self.self_modulate = Color(1.0, 1.0, 1.0, 1.0)
