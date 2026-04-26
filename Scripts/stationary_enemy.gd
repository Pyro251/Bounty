extends CharacterBody2D

@onready var body: ProgressBar = $Body
@onready var explosion_particles: GPUParticles2D = $ExplosionParticles
@onready var shoot_pos: Marker2D = $ShootPos
@onready var shoot_speed_timer: Timer = $ShootSpeedTimer
@onready var shoot_sound: AudioStreamPlayer2D = $ShootSound
@onready var explode_sound: AudioStreamPlayer2D = $ExplodeSound
@onready var coin_spawn_1: Marker2D = $CoinSpawn1
@onready var coin_spawn_2: Marker2D = $CoinSpawn2
@onready var coin_spawn_3: Marker2D = $CoinSpawn3

@export var target: Node = null

var health: int = 100
var can_die: bool = true
var player_detected: bool = false


const BULLET_SCENE = preload("res://Scenes/Enemies/enemy_bullet.tscn")
const COIN_DROP_SCENE = preload("res://Scenes/Collectables/Money/enemy_coin_drop.tscn")

func _on_bullet_detect_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_bullet"):
		health -= 20

func _ready() -> void:
	player_detected = false

func _physics_process(delta: float) -> void:
	body.value = health
	
	if health <= 0 and can_die:
		die()
	
	if player_detected:
		self.look_at(target.global_position)

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

func add_money_collectable():
	var spawn_quantity = randi_range(3,6)
	var new_coin
	
	for i in spawn_quantity:
		new_coin = COIN_DROP_SCENE.instantiate()
		get_parent().add_child(new_coin)
		new_coin.global_position = self.global_position
		spawn_quantity = randi_range(3, 6)
	#maybe make it so they drop ammo too??

func _on_explosion_particles_finished() -> void:
	queue_free()

func _shoot():
	shoot_sound.play()
	var new_bullet = BULLET_SCENE.instantiate()
	new_bullet.global_position = shoot_pos.global_position
	new_bullet.global_rotation = shoot_pos.global_rotation
	get_parent().add_child(new_bullet)


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
