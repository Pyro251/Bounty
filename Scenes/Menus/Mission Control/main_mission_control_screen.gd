extends Control

@onready var select_mission_text_anim: AnimationPlayer = $SelectMissionAnim
@onready var exchange_text_anim: AnimationPlayer = $ExchangeTextAnim
@onready var missions_text_panel: Panel = $MissionsTextPanel
@onready var select_mission: Label = $SelectMission
@onready var whoosh_sound: AudioStreamPlayer = $WhooshSound
@onready var click_sound: AudioStreamPlayer = $ClickSound

var can_anim: bool = true

func _ready() -> void:
	Global.mission_selected.connect(mission_selected)
	Global.show_alert = false

func update_mission_text():
	$MissionsTextPanel/MissionsText.text = Global.mission_panel_text

func mission_selected():
	can_anim = true
	
	if missions_text_panel.visible == true:
		exchange_text_anim.play("out")
		
		if Global.mission_selected_var:
			select_mission_text_anim.play("out")
		
	else:
		exchange_text_anim.play("in")
		update_mission_text()
		can_anim = false
		
	
	select_mission_text_anim.play("out")
	
	missions_text_panel.show()


func _on_exchange_text_anim_animation_finished(out) -> void:
	if can_anim:
		exchange_text_anim.play("in")
		update_mission_text()
		can_anim = false
		click_sound.play()


func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/base.tscn")




func _on_exchange_text_anim_animation_started(out) -> void:
	whoosh_sound.play()


func _on_select_mission_anim_animation_finished(anim_name: StringName) -> void:
	select_mission.hide()
