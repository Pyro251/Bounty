extends CharacterBody2D

@onready var body: ProgressBar = $Body
@onready var bullet_explosion_particles: GPUParticles2D = $BulletExplosionParticles
@onready var shoot_pos: Marker2D = $ShootPos
@onready var shoot_speed_timer: Timer = $ShootSpeedTimer
@onready var shoot_sound: AudioStreamPlayer2D = $ShootSound
@onready var explode_sound: AudioStreamPlayer2D = $ExplodeSound
@onready var hit_sound: AudioStreamPlayer2D = $HitSound
@onready var coin_spawn_1: Marker2D = $CoinSpawn1
@onready var coin_spawn_2: Marker2D = $CoinSpawn2
@onready var coin_spawn_3: Marker2D = $CoinSpawn3
@onready var explosion_radius: CollisionShape2D = $ExplodeArea/ExplosionRadius

@export var Goal: Node = null
@export var target: Node = null

var health: int = 100
var can_die: bool = true
var player_detected: bool = false
var in_exploding_area: bool = false
var total_explosion_chance: int = randi_range(1, 100)


const BULLET_SCENE = preload("res://Scenes/Enemies/enemy_bullet.tscn")
const COIN_DROP_SCENE = preload("res://Scenes/Collectables/Money/enemy_coin_drop.tscn")
const HEALTH_DROP_SCENE = preload("res://Scenes/Collectables/Health/enemy_health_drop.tscn")
const EXPLOSION_PARTICLES = preload("res://Scenes/Enemies/explosion_particles.tscn")
const DAMAGE_COUNTER = preload("res://Scenes/Animations/damage_counter.tscn")

func _on_bullet_detect_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_bullet"):
		health -= Global.attack_damage
		if Global.bullet_explosion_chance >= total_explosion_chance:
			bullet_explosion_particles.emitting = true
			health -= Global.attack_damage + 20
			Global.bullet_exploded.emit()
		
		hit_sound.play()
		
		add_damage_counter()

func _ready() -> void:
	player_detected = false
	target = get_parent().get_node("Player")
	Global.bullet_exploded.connect(explode_bullet)

func _physics_process(delta: float) -> void:
	body.value = health
	
	if health <= 0 and can_die:
		die()
	
	if player_detected:
		self.look_at(target.global_position)
	
	bullet_explosion_particles.scale = Vector2(Global.bullet_explosion_radius, Global.bullet_explosion_radius)
	explosion_radius.scale = Vector2(Global.bullet_explosion_radius, Global.bullet_explosion_radius)

func die():
	explode_sound.play()
	Global.enemy_killed.emit()
	body.hide()
	can_die = false
	Global.enemies_killed += 1
	print("enemies killed: ", Global.enemies_killed)
	print("total enemies in level: ", Global.enemies_in_current_level)
	print("enemies left to kill: ", Global.enemies_in_current_level - Global.enemies_killed)
	
	# Spawns some coins on death.
	add_money_collectable()
	
	add_exposion_particles()
	
	
	queue_free()

func add_exposion_particles():
	var new_particles
	
	new_particles = EXPLOSION_PARTICLES.instantiate()
	get_parent().add_child(new_particles)
	new_particles.global_position = self.global_position

func add_damage_counter():
	var new_particles
	
	new_particles = DAMAGE_COUNTER.instantiate()
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

func _shoot():
	if !Global.in_tutorial:
		shoot_sound.play()
		var new_bullet = BULLET_SCENE.instantiate()
		new_bullet.global_position = shoot_pos.global_position
		new_bullet.global_rotation = shoot_pos.global_rotation
		get_parent().add_child(new_bullet)

func explode_bullet():
	if in_exploding_area:
		explode_sound.play()
		health -= Global.attack_damage + 20

func _on_player_detect_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		shoot_speed_timer.start()
		player_detected = true


func _on_player_detect_area_exited(area: Area2D) -> void:
	player_detected = false


func _on_shoot_speed_timer_timeout() -> void:
	if player_detected:
		_shoot()
		shoot_speed_timer.start()


func _on_explode_area_area_entered(area: Area2D) -> void:
	in_exploding_area = true


func _on_explode_area_area_exited(area: Area2D) -> void:
	in_exploding_area = false
