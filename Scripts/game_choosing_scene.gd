extends Control

@onready var mock_player: Panel = $Scene2/Scene2Panel/MockPlayer
@onready var bg: ColorRect = $BG
@onready var scene_1: Control = $Scene1
@onready var scene_2: Control = $Scene2
@onready var loading_screen: Node2D = $loading_screen

@onready var bg_anims: AnimationPlayer = $bgAnims
@onready var scene_1_anims: AnimationPlayer = $Scene1Anims
@onready var scene_2_anims: AnimationPlayer = $Scene2Anims

var can_load: bool = true

func _ready() -> void:
	start()

func start():
	bg.show()
	scene_1.show()
	bg_anims.play("in")
	scene_1_anims.play("in")

func _on_only_action_button_pressed() -> void:
	Global.game_type.action_packed = true
	move_to_scene_2()


func _on_campaign_button_pressed() -> void:
	Global.game_type.campaign = true
	move_to_scene_2()


func _on_speedrun_button_pressed() -> void:
	Global.game_type.speed_run = true
	move_to_scene_2()

func move_to_scene_2():
	scene_1_anims.play("out")
	scene_2.show()
	scene_2_anims.play("in")


func _on_color_picker_color_changed(color: Color) -> void:
	mock_player.modulate = color
	Global.player_color = color


func _on_start_game_pressed() -> void:
	scene_2_anims.play("out")
	loading_screen.show()
	$loading_screen/ProgressBar/AnimationPlayer.play("Fill bar")
	can_load = false


func _on_loading_screen_loaded() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/base.tscn")
