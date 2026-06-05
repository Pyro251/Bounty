extends Node2D


@onready var bullet: ColorRect = $ColorRect
#@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var distance_timeout: Timer = $distance_timeout
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var speed: float = 2000

func _ready() -> void:
	print("bullet instanciated")
	animation_player.play("appear")
	
	modulate = Global.player_color

func _physics_process(delta: float) -> void:
	global_position += Vector2(0, -1).rotated(rotation) * speed * delta
	


func _on_area_2d_area_entered(area: Area2D) -> void:
	queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy") or body.is_in_group("walls"):
		queue_free()
