extends RigidBody2D

@export var magnet_speed: float = 8.0


var magnet_on: bool = false
var random_spawn_point: int = randi_range(1,3)

func _ready() -> void:
	angular_velocity = randf_range(-50, 50)
	rotation = randf_range(1, 360)
	global_position.x += randf_range(-50,50)
	global_position.y += randf_range(-50,50)


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
	if is_in_group("money"):
		if area.is_in_group("player"):
			var random_money = randi_range(5, 15)
			Global.player_money += random_money
			Global.money_made_this_level += random_money
			Global.money_collected.emit()
			print("Coin collected.")
			queue_free()
	if is_in_group("health"):
		if area.is_in_group("player"):
			var random_health = randi_range(10, 20)
			Global.player_health += random_health
			print("Health collected.")
			queue_free()
