extends Camera2D

@export var max_shake: float = 7.0
@export var shake_fade: float = 10.0

@onready var current_ammo: Label = $CanvasLayer/CurrentAmmo
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var level_prep: Control = $LevelPrep
@onready var player_ui: CanvasLayer = $PlayerUI
@onready var playercamera: Camera2D = $"."

var desired_offset: Vector2
var min_offset = -200
var max_offset = 200
var _shake_strength: float = 0.0

func _ready() -> void:
	Global.hide_player_ui.connect(hide_player_ui)
	
	
	playercamera.enabled = true
	
	Global.shoot.connect(trigger_shake)
	Global.player_damaged.connect(trigger_shake)
	Global.trigger_camera_shake.connect(trigger_shake)

func _process(delta: float) -> void:
	desired_offset = (get_global_mouse_position()-position) * 0.5
	desired_offset.x = clamp(desired_offset.x, min_offset, max_offset)
	desired_offset.y = clamp(desired_offset.y, min_offset / 2.0, max_offset / 2.0)
	
	global_position = get_parent().get_node("Player").global_position + desired_offset
	
	if _shake_strength > 0:
		_shake_strength = lerp(_shake_strength, 0.0, shake_fade * delta)
		offset = Vector2(randf_range(-_shake_strength, _shake_strength), randf_range(-_shake_strength, _shake_strength))
	

func hide_player_ui():
	player_ui.hide()

func trigger_shake() -> void:
	_shake_strength = max_shake
