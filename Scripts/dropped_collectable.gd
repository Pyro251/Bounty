extends RigidBody2D

@export var magnet_speed: float = 8.0

@onready var coin_spawn_1: Marker2D = $CoinSpawn1
@onready var coin_spawn_2: Marker2D = $CoinSpawn2
@onready var coin_spawn_3: Marker2D = $CoinSpawn3

var magnet_on: bool = false
var random_spawn_point: int = randi_range(1,3)

func _ready() -> void:
	angular_velocity = randf_range(-50, 50)
	rotation = randf_range(1, 360)
	global_position.x += randf_range(-50,50)
	global_position.y += randf_range(-50,50)
	
	#match random_spawn_point:
		#1:
			#global_position = coin_spawn_1.global_position
		#2:
			#global_position = coin_spawn_2.global_position
		#3:
			#global_position = coin_spawn_3.global_position
	
	#random_spawn_point = randi_range(1,3)


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
	if area.is_in_group("player"):
		Global.player_money += randi_range(5, 15)
		Global.money_collected.emit()
		queue_free()
