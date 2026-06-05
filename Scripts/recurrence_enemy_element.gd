extends Node2D

@onready var recurrence_pivot: Marker2D = $RecurrencePivot
@onready var recurrence_shoot_pos: Marker2D = $RecurrencePivot/RecurrenceShootPos

const BULLET_SCENE = preload("res://Scenes/Weapons/Bullet/bullet.tscn")

func activate_recurrence():
	print("recurrence activated")
	recurrence_pivot.global_rotation = randf_range(-360, 360)
	
	var new_bullet = BULLET_SCENE.instantiate()
	new_bullet.global_position = recurrence_shoot_pos.global_position
	new_bullet.global_rotation = recurrence_shoot_pos.global_rotation
	get_parent().add_child(new_bullet)
