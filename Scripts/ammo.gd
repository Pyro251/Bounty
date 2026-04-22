extends Node2D

var magnet_on: bool = false
var magnet_speed: float = 10.0

func _physics_process(delta: float) -> void:
	#if magnet_on and !Global.chest_in_anim:
	if magnet_on:
		self.global_position = self.global_position.lerp(Global.player_pos, delta * magnet_speed)

func _on_magnet_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		magnet_on = true


func _on_collecting_area_entered(area: Area2D) -> void:
	queue_free()
