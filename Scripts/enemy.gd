extends CharacterBody2D

@onready var body: ProgressBar = $Body
@onready var explosion_particles: GPUParticles2D = $ExplosionParticles
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var collision2: CollisionShape2D = $BulletDetect/CollisionShape2D
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var timer: Timer = $Timer

@export var Goal: Node = null

var health = 100
var can_die: bool = true

const MOVEMENT_SPEED = 10000.0

func _ready() -> void:
	nav_agent.target_position = Goal.global_position

func _physics_process(delta: float) -> void:
	
	
	if !nav_agent.is_target_reached():
		var nav_point_direction = to_local(nav_agent.get_next_path_position()).normalized()
		velocity = nav_point_direction * MOVEMENT_SPEED * delta
		move_and_slide()
	
	
	body.value = health
	if health < 0:
		health = 0
	if health == 0 and can_die:
		can_die = false
		die()


func _on_bullet_detect_area_entered(area: Area2D) -> void:
	health -= Global.bullet_damage

func die():
	Global.enemy_killed.emit()
	Global.player_money += 20
	trigger_explosion()
	body.hide()
	#collision.disabled = true
	#collision2.disabled = true

func trigger_explosion():
	explosion_particles.emitting = true


func _on_explosion_particles_finished() -> void:
	print("queueing free")
	queue_free()


func _on_timer_timeout() -> void:
	if nav_agent.target_position != Goal.global_position:
		nav_agent.target_position = Goal.global_position
	timer.start()


func _on_player_detection_area_entered(area: Area2D) -> void:
	timer.start()


func _on_player_detection_area_exited(area: Area2D) -> void:
	timer.stop()
