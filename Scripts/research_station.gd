extends Node2D

@onready var press_e: Label = $pressE

var in_area: bool = false

func _ready() -> void:
	press_e.hide()

func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("interact"):
		if in_area:
			get_tree().change_scene_to_file("res://Scenes/Menus/research_tree.tscn")

func _on_area_2d_area_entered(area: Area2D) -> void:
	in_area = true
	press_e.show()


func _on_area_2d_area_exited(area: Area2D) -> void:
	in_area = false
	press_e.hide()
