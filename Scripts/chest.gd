extends Node2D

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var timer: Timer = $Timer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collection_particles: GPUParticles2D = $CollectionParticles
@onready var _1: Marker2D = $"1"
@onready var _2: Marker2D = $"2"
@onready var _3: Marker2D = $"3"

var mouse_in
var random_spawn = randi_range(1, 3)
var new_ammo = AMMO_SCENE.instantiate()


const AMMO_SCENE = preload("res://Scenes/Collectables/Ammo/ammo.tscn")

func _ready() -> void:
	
	progress_bar.show()
	



func _physics_process(delta: float) -> void:
	
	var timer_value: float = timer.time_left
	
	if mouse_in:
		progress_bar.self_modulate = Color(1.0, 1.0, 1.0, 1.0)
		if Input.is_action_just_pressed("collect_chest"):
			timer.start()
		if Input.is_action_just_released("collect_chest"):
			timer.stop()
	else:
		progress_bar.self_modulate = Color(0.329, 0.329, 0.329, 1.0)
		timer.stop()
	
	if Global.chest_in_anim:
		new_ammo.global_position = _1.global_position
	
	
	
	
	progress_bar.value = timer_value


func _on_area_2d_area_entered(area: Area2D) -> void:
	mouse_in = true


func _on_area_2d_area_exited(area: Area2D) -> void:
	mouse_in = false


func _on_timer_timeout() -> void:
	
	get_parent().add_child(new_ammo)
	new_ammo.global_rotation = randi_range(1, 180)
	
	progress_bar.hide()
	collection_particles.emitting = true
	animation_player.play("open")
	
	#queue_free()


#func _spawn_random():
	


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	Global.chest_in_anim = false
