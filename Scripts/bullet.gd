extends Node2D


@onready var bullet: ColorRect = $ColorRect
#@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var distance_timeout: Timer = $distance_timeout
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var speed: float = 2000

func _ready() -> void:
	animation_player.play("appear")

func _physics_process(delta: float) -> void:
	global_position += Vector2(0, -1).rotated(rotation) * speed * delta
	


func _on_area_2d_area_entered(area: Area2D) -> void:
	queue_free()
