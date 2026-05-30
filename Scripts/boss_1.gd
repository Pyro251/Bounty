extends CharacterBody2D

@onready var shoot_speed_timer: Timer = $ShootSpeed
@onready var shoot_sound: AudioStreamPlayer2D = $Sounds/ShootSound
@onready var hit_sound: AudioStreamPlayer2D = $Sounds/HitSound
@onready var body: ProgressBar = $Body
@onready var bullet_rotation_anim: AnimationPlayer = $BulletRotationAnim

@export var boss_level: int = 1
@export var attack_damage: float = 35.0
@export var stationary: bool = true

const COIN_DROP_SCENE = preload("res://Scenes/Collectables/Money/enemy_coin_drop.tscn")
const HEALTH_DROP_SCENE = preload("res://Scenes/Collectables/Health/enemy_health_drop.tscn")
const BULLET_SCENE = preload("res://Scenes/Enemies/Bosses/Projectiles/boss_bullet.tscn")
const EXPLOSION_PARTICLES = preload("res://Scenes/Enemies/explosion_particles.tscn")
const DAMAGE_COUNTER = preload("res://Scenes/Animations/damage_counter.tscn")

var boss_activated: bool = false
var current_shoot_pos_number: int = 1
var health: float


func _ready() -> void:
	hide()
	
	Global.trigger_boss.connect(activate_boss)
	
	match boss_level:
		1:
			health = 700
			bullet_rotation_anim.play("rotate")
	
	body.max_value = health

func _process(delta: float) -> void:
	if current_shoot_pos_number == 9:
		current_shoot_pos_number = 1
	
	if health <= 0:
		die()
	
	body.value = health

# custom signal activated functions

func activate_boss():
	boss_activated = true
	shoot_speed_timer.start()
	show()

# Custom functions

func _shoot():
	var current_shoot_pos = get_node(str("BulletSpawnPoints/Spawn", current_shoot_pos_number))
	
	var new_bullet = BULLET_SCENE.instantiate()
	new_bullet.global_position = current_shoot_pos.global_position
	new_bullet.global_rotation = current_shoot_pos.global_rotation
	get_parent().add_child(new_bullet)
	
	current_shoot_pos_number += 1

func die():
	add_exposion_particles()
	add_collectables()
	Global.enemies_killed += 1
	Global.enemy_killed.emit()
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

func add_collectables():
	var spawn_quantity = randi_range(20,25)
	var new_coin
	var new_health
	
	var random = RandomNumberGenerator.new()
	var spawn_items: Array = ["coins", "health"]
	var spawn_weights: Array = [1, 0.2]
	
	for i in spawn_quantity:
		match spawn_items[random.rand_weighted(spawn_weights)]:
			"coins":
				new_coin = COIN_DROP_SCENE.instantiate()
				get_parent().add_child(new_coin)
				new_coin.global_position = Vector2(global_position.x + randf_range(-50, 50), global_position.y + randf_range(-50, 50))
			"health":
				new_health = HEALTH_DROP_SCENE.instantiate()
				get_parent().add_child(new_health)
				new_health.global_position = Vector2(global_position.x + randf_range(-50, 50), global_position.y + randf_range(-50, 50))

# Connected area signals

func _on_boss_activation_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		activate_boss()

func _on_shoot_speed_timeout() -> void:
	
	for i in 8:
		_shoot()
	
	shoot_sound.play()


func _on_bullet_detection_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_bullet"):
		add_damage_counter()
		hit_sound.play()
		health -= Global.attack_damage
