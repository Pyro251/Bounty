extends StaticBody2D

@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var hit_sound: AudioStreamPlayer2D = $HitSound

const DAMAGE_COUNTER = preload("res://Scenes/Animations/damage_counter.tscn")

func _on_bullet_detect_area_entered(area: Area2D) -> void:
	anim_player.play("hit")
	
	add_damage_counter()
	
	hit_sound.play()
	$ToolTip.hide()

func add_damage_counter():
	var new_particles
	
	new_particles = DAMAGE_COUNTER.instantiate()
	get_parent().add_child(new_particles)
	new_particles.global_position = self.global_position
