extends Node2D

@onready var press_e: Label = $pressE
@onready var alert_label: Label = $AlertLabel
@onready var anim_player: AnimationPlayer = $AnimationPlayer

var in_area: bool = false

func _ready() -> void:
	press_e.hide()

func _physics_process(delta: float) -> void:
	
	if Global.show_alert:
		alert_label.show()
	else:
		alert_label.hide()
	
	if Input.is_action_just_pressed("interact"):
		if in_area:
			SaveLoad._set_save_data()
			SaveLoad._save()
			SaveLoad._load()
			SaveLoad._set_load_data()
			get_tree().change_scene_to_file("res://Scenes/Menus/Mission Control/main_mission_control_screen.tscn")


func _on_area_2d_area_entered(area: Area2D) -> void:
	in_area = true
	press_e.show()


func _on_area_2d_area_exited(area: Area2D) -> void:
	in_area = false
	press_e.hide()
