extends TextureButton
class_name SkillNode

@export var max_level: int = 3
@export var levels_to_unlock_next_level: int = 3
@export var variable_to_change: String
@export var group_name: String
@export var value_to_add: float
@export var value_to_subtract: float
@export var cost: String

@export_multiline var short_description: String

@export var upgrade_name: String
@export var upgrade_level: String

@onready var panel: Panel = $Panel
@onready var label: Label = $MarginContainer/Label
@onready var line_2d: Line2D = $Line2D
@onready var accept_anim: AnimationPlayer = $AcceptAnim
@onready var reject_anim: AnimationPlayer = $RejectAnim
@onready var reject_sound: AudioStreamPlayer = $RejectSound
@onready var accept_sound: AudioStreamPlayer = $AcceptSound
@onready var hover_on_sound: AudioStreamPlayer = $HoverOn
@onready var hover_off_sound: AudioStreamPlayer = $HoverOff
@onready var hover_on_anim: AnimationPlayer = $HoverOnAnim
@onready var hover_off_anim: AnimationPlayer = $HoverOffAnim
@onready var max_level_reached_sound: AudioStreamPlayer = $MaxLevelReachedSound

@onready var text_box: PanelContainer = $TextBox
@onready var text_label: RichTextLabel = $TextBox/MarginContainer/Text

#var format_string: String = "%s - %s/n %s/n Cost: %s"
#var actual_string: String = format_string % [upgrade_name, level, short_description, cost]
var hover_scale: Vector2 = Vector2(1.1, 1.1)
var pressed_scale: Vector2 = Vector2(0.9, 0.9)


var level: int = 0:
	set(value):
		level = value
		label.text = str(level, "/", max_level)

func _ready() -> void:
	self.add_to_group(group_name)
	
	if !Global.abilities.has(group_name):
		Global.abilities[group_name] = 0
		print(Global.abilities)
	
	#print(actual_string)
	text_label.text = str(upgrade_name, " - ", upgrade_level, "\n\n", short_description, "\n\n", "Cost: ", cost)
	
	
	if get_parent() is SkillNode:
		line_2d.add_point(self.global_position + self.size / 2)
		line_2d.add_point(get_parent().global_position + get_parent().size / 2)
	
	level = Global.abilities.get(group_name)
	if level > 0:
		self.self_modulate = Color(1.0, 1.0, 1.0, 1.0)
		line_2d.default_color = Color(1.0, 1.0, 1.0, 1.0)
	
	if get_parent() is SkillNode:
		hide()
	else:
		show()
	
	

	disabled = false
	
	
	
	print("level ", level)

 
func _physics_process(delta: float) -> void:
	var skills = get_children()
	for skill in skills:
		if skill is SkillNode and level == levels_to_unlock_next_level:
			skill.show()
	
	if level == max_level:
		self_modulate = Color(0.71, 0.555, 0.0, 1.0)


func _on_pressed() -> void:
	
	
	
	if level < max_level:
		var var_to_change = Global.get(variable_to_change)
		var levels_till_next_level
		
		if get_parent().is_class("SkillNode"):
			levels_till_next_level = get_parent().get_script()[levels_to_unlock_next_level]
		else:
			levels_till_next_level = 0
		
		if Global.player_money >= int(cost) and level >= levels_till_next_level:
			var_to_change += value_to_add
			var_to_change -= value_to_subtract
			Global.player_money -= int(cost)
			level = min(level + 1, max_level)
			Global.abilities[group_name] += 1
			print("level ", level)
			print(Global.abilities)
			if level == max_level:
				max_level_reached_sound.play()
			Global.set(variable_to_change, var_to_change)
			print(var_to_change)
			accept()
		else:
			reject()
	else:
		reject()
	
	
	# Handels actually giving the player the ability.
	#if level < max_level:
		## Health upgrades
		#if self.is_in_group("health1"):
			#if Global.player_money >= 100:
				#Global.max_player_health += 5.0
				#Global.player_money -= 100
				#Global.health1 += 1
				#accept()
			#else:
				#reject()
		#if self.is_in_group("health2"):
			#if Global.player_money >= 400:
				#Global.max_player_health += 15.0
				#Global.player_money -= 400
				#Global.health2 += 1
				#accept()
			#else:
				#reject()
		#if self.is_in_group("regen1"):
			#if Global.player_money >= 700:
				#Global.health_per_enemy_health_collectable += 15
				#Global.player_money -= 700
				#Global.regen1 += 1
				#accept()
			#else:
				#reject()
		## Attack upgrades
		#if self.is_in_group("attack1"):
			#if Global.player_money >= 100:
				#Global.attack_damage += 5
				#Global.player_money -= 100
				#Global.attack1 += 1
				#accept()
			#else:
				#reject()
		#if self.is_in_group("attack2"):
			#if Global.player_money >= 400:
				#Global.attack_damage += 15
				#Global.player_money -= 400
				#Global.attack2 += 1
				#accept()
			#else:
				#reject()
		#if self.is_in_group("attack_speed1"):
			#if Global.player_money >= 600:
				#Global.attack_speed -= 0.03
				#Global.player_money -= 600
				#Global.attack_speed1 = min(Global.attack_speed1 + 1, max_level)
				#accept()
			#else:
				#reject()

func accept():
	accept_sound.play()
	accept_sound.pitch_scale += 0.4
	accept_anim.play("Accept")
	self.self_modulate = Color(1.0, 1.0, 1.0, 1.0)
	line_2d.default_color = Color(1.0, 1.0, 1.0, 1.0)

func reject():
	reject_sound.play()
	reject_anim.play("Reject")


func _on_mouse_entered() -> void:
	create_tween().tween_property(self, "scale", hover_scale, 0.1).set_trans(Tween.TRANS_SINE)
	text_box.show()
	hover_on_anim.play("hover_on")
	hover_on_sound.play()


func _on_mouse_exited() -> void:
	create_tween().tween_property(self, "scale", Vector2.ONE, 0.1).set_trans(Tween.TRANS_SINE)
	hover_off_anim.play("hover_off")
	hover_off_sound.play()


func _on_hover_off_anim_animation_finished(anim_name: StringName) -> void:
	text_box.hide()
