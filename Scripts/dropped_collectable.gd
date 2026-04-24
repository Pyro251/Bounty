extends RigidBody2D

@export var magnet_speed: float = 5.0

var magnet_on: bool = false

func _ready() -> void:
	angular_velocity = randf_range(5, 50)
	rotation = randf_range(1, 360)
	position.x += randf_range(1,50)
	position.y += randf_range(1,50)

func _physics_process(delta: float) -> void:
	if magnet_on:
		global_position = global_position.lerp(Global.player_pos, delta * magnet_speed)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		magnet_on = true


func _on_magnet_area_exited(area: Area2D) -> void:
	if area.is_in_group("player"):
		magnet_on = false


func _on_collect_area_entered(area: Area2D) -> void:
	Global.player_money += randi_range(50, 70)
	Global.money_collected.emit()
	queue_free()
