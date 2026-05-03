extends CharacterBody2D

@onready var body: ProgressBar = $Body
@onready var explosion_particles: GPUParticles2D = $ExplosionParticles
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var collision2: CollisionShape2D = $BulletDetect/CollisionShape2D
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var timer: Timer = $Timer
@onready var explode_timer: Timer = $ExplodeTimer

@onready var shoot_speed_timer: Timer = $ShootSpeedTimer
@onready var shoot_sound: AudioStreamPlayer2D = $ShootSound
@onready var explode_sound: AudioStreamPlayer2D = $ExplodeSound

@export var Goal: Node = null
@export var target: Node = null

var player_detected: bool = false


var health = 100
var can_die: bool = true
var can_explode_player = false

const MOVEMENT_SPEED = 20000.0
const COIN_DROP_SCENE = preload("res://Scenes/Collectables/Money/enemy_coin_drop.tscn")
const HEALTH_DROP_SCENE = preload("res://Scenes/Collectables/Health/enemy_health_drop.tscn")

func _ready() -> void:
	nav_agent.target_position = Goal.global_position
	player_detected = false
	target = get_parent().get_node("Player")

func _physics_process(delta: float) -> void:
	
	
	if !nav_agent.is_target_reached() and player_detected:
		var nav_point_direction = to_local(nav_agent.get_next_path_position()).normalized()
		velocity = nav_point_direction * MOVEMENT_SPEED * delta
		move_and_slide()
	
	
	body.value = health
	if health < 0:
		health = 0
	if health == 0 and can_die:
		can_die = false
		die()
	
	#if player_detected:
		#body.look_at(target.global_position)




func _on_bullet_detect_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_bullet"):
		health -= Global.attack_damage


func die():
	explode_sound.play()
	Global.enemy_killed.emit()
	explosion_particles.emitting = true
	body.hide()
	can_die = false
	Global.enemies_killed += 1
	print("enemies killed: ", Global.enemies_killed)
	print("total enemies in level: ", Global.enemies_in_current_level)
	print("enemies left to kill: ", Global.enemies_in_current_level - Global.enemies_killed)
	
	# Spawns some coins on death.
	add_money_collectable()

func target_explode():
	explode_timer.start()

func add_money_collectable():
	var spawn_quantity = randi_range(3,6)
	var new_coin
	var new_health
	
	for i in spawn_quantity:
		var random_num = randi_range(1,3)
		match random_num:
			1:
				new_coin = COIN_DROP_SCENE.instantiate()
				get_parent().add_child(new_coin)
				new_coin.global_position = self.global_position
			2:
				new_coin = COIN_DROP_SCENE.instantiate()
				get_parent().add_child(new_coin)
				new_coin.global_position = self.global_position
			3:
				new_health = HEALTH_DROP_SCENE.instantiate()
				get_parent().add_child(new_health)
				new_health.global_position = self.global_position
		spawn_quantity = randi_range(3, 6)
		random_num = randi_range(1,3)
		
	#maybe make it so they drop ammo too??
	#no??

func _on_explosion_particles_finished() -> void:
	queue_free()

func _on_timer_timeout() -> void:
	if player_detected:
		if nav_agent.target_position != Goal.global_position:
			nav_agent.target_position = Goal.global_position
		timer.start()


func _on_player_detection_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		player_detected = true
		target_explode()
		
		timer.start() 


func _on_explode_timer_timeout() -> void:
	player_detected = false
	body.hide()
	explosion_particles.emitting = true
	if can_explode_player:
		Global.explode_player.emit()


func _on_explosion_detect_area_entered(area: Area2D) -> void:
	can_explode_player = true


func _on_explosion_detect_area_exited(area: Area2D) -> void:
	can_explode_player = false
