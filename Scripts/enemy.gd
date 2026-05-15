extends CharacterBody2D

@onready var pivot: Node2D = $Pivot
@onready var body: ProgressBar = $Pivot/Body
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var collision2: CollisionShape2D = $BulletDetect/CollisionShape2D
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var timer: Timer = $Timer

@onready var shoot_pos: Marker2D = $Pivot/Body/ShootPos
@onready var shoot_speed_timer: Timer = $ShootSpeedTimer
@onready var shoot_sound: AudioStreamPlayer2D = $ShootSound

@export var Goal: Node = null
@export var target: Node = null

var player_detected: bool = false


var health = 100
var can_die: bool = true

const MOVEMENT_SPEED = 10000.0
const BULLET_SCENE = preload("res://Scenes/Enemies/enemy_bullet.tscn")
const COIN_DROP_SCENE = preload("res://Scenes/Collectables/Money/enemy_coin_drop.tscn")
const HEALTH_DROP_SCENE = preload("res://Scenes/Collectables/Health/enemy_health_drop.tscn")
const EXPLOSION_PARTICLES = preload("res://Scenes/Enemies/explosion_particles.tscn")


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
	
	pivot.look_at(target.global_position)
	
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
	Global.enemy_killed.emit()
	
	body.hide()
	can_die = false
	Global.enemies_killed += 1
	print("enemies killed: ", Global.enemies_killed)
	print("total enemies in level: ", Global.enemies_in_current_level)
	print("enemies left to kill: ", Global.enemies_in_current_level - Global.enemies_killed)
	
	add_exposion_particles()
	
	# Spawns some coins on death.
	add_money_collectable()
	
	queue_free()

func add_exposion_particles():
	var new_particles
	
	new_particles = EXPLOSION_PARTICLES.instantiate()
	get_parent().add_child(new_particles)
	new_particles.global_position = self.global_position

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


func _shoot():
	shoot_sound.play()
	var new_bullet = BULLET_SCENE.instantiate()
	new_bullet.global_position = shoot_pos.global_position
	new_bullet.global_rotation = shoot_pos.global_rotation
	get_parent().add_child(new_bullet)



func _on_timer_timeout() -> void:
	if player_detected:
		if nav_agent.target_position != Goal.global_position:
			nav_agent.target_position = Goal.global_position
		timer.start()


func _on_player_detection_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		_shoot()
		shoot_speed_timer.start()
		player_detected = true
		
		timer.start()


func _on_player_detection_area_exited(area: Area2D) -> void:
	timer.stop()
	shoot_speed_timer.stop()
	player_detected = false


func _on_shoot_speed_timer_timeout() -> void:
	if player_detected:
		_shoot()
