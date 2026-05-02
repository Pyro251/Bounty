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
@onready var text_label: RichTextLabel = $TextBox/MarginContainer/Text



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
	
	if self.is_in_group("health1"):
		level = Global.health1
		if Global.health1 > 0 :
			self.self_modulate = Color(1.0, 1.0, 1.0, 1.0)
			line_2d.default_color = Color(1.0, 1.0, 1.0, 1.0)
	if self.is_in_group("health2"):
		level = Global.health2
		if Global.health2 > 0 :
			self.self_modulate = Color(1.0, 1.0, 1.0, 1.0)
			line_2d.default_color = Color(1.0, 1.0, 1.0, 1.0)
	if self.is_in_group("regen1"):
		level = Global.regen1
		if Global.regen1 > 0 :
			self.self_modulate = Color(1.0, 1.0, 1.0, 1.0)
			line_2d.default_color = Color(1.0, 1.0, 1.0, 1.0)
	
	disabled = false
	#var skills = get_children()
	#for skill in skills:
		#if skill is SkillNode and level == levels_to_unlock_next_level:
			#skill.disabled = false

#func _on_pressed() -> void:



func _on_pressed() -> void:
	
	
	# Handels how much it can be upgraded
	var skills = get_children()
	for skill in skills:
		if skill is SkillNode and level == levels_to_unlock_next_level:
			skill.disabled = false
	
	
	# Handels actually giving the player the ability.
	if level < max_level:
		# Health upgrades
		if self.is_in_group("health1"):
			if Global.player_money >= 100:
				Global.max_player_health += 5.0
				Global.player_money -= 100
				Global.health1 = min(Global.health1 + 1, max_level)
				accept()
			else:
				reject()
		if self.is_in_group("health2"):
			if Global.player_money >= 400:
				Global.max_player_health += 15.0
				Global.player_money -= 400
				Global.health2 = min(Global.health2 + 1, max_level)
				accept()
			else:
				reject()
		if self.is_in_group("regen1"):
			if Global.player_money >= 700:
				Global.health_per_enemy_health_collectable += 15
				Global.player_money -= 700
				Global.regen1 = min(Global.regen1 + 1, max_level)
				accept()
			else:
				reject()
		# Attack upgrades
		if self.is_in_group("attack1"):
			if Global.player_money >= 100:
				Global.attack_damage += 5
				Global.player_money -= 100
				Global.attack1 = min(Global.attack1 + 1, max_level)
				accept()
			else:
				reject()
		if self.is_in_group("attack2"):
			if Global.player_money >= 400:
				Global.attack_damage += 15
				Global.player_money -= 400
				Global.attack2 = min(Global.attack2 + 1, max_level)
				accept()
			else:
				reject()
		if self.is_in_group("attack_speed1"):
			if Global.player_money >= 600:
				Global.attack_speed -= 0.03
				Global.player_money -= 600
				Global.attack_speed1 = min(Global.attack_speed1 + 1, max_level)
				accept()
			else:
				reject()

func accept():
	accept_anim.play("Accept")
	level = min(level + 1, max_level)
	self.self_modulate = Color(1.0, 1.0, 1.0, 1.0)
	line_2d.default_color = Color(1.0, 1.0, 1.0, 1.0)

func reject():
	reject_sound.play()
	reject_anim.play("Reject")




func _on_mouse_entered() -> void:
	text_box.show()


func _on_mouse_exited() -> void:
	text_box.hide()
