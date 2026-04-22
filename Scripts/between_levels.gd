extends Control

@onready var levels_anim: AnimationPlayer = $Levels

func _ready() -> void:
	levels_anim.play("level_1_entered_animation_start")

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/base.tscn")

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("skip"):
		get_tree().change_scene_to_file("res://Scenes/Levels/base.tscn")
