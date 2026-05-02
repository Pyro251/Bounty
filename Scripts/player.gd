extends CharacterBody2D

@export var player_speed: float = 650.0

# Sounds
@onready var close_ready_prep_sound: AudioStreamPlayer = $Sounds/CloseReadyPrepSound
@onready var shoot_sound: AudioStreamPlayer = $Sounds/ShootSound
@onready var pickup_ammo_sound: AudioStreamPlayer = $Sounds/PickupAmmoSound
@onready var level_cleared_sound: AudioStreamPlayer = $Sounds/LevelClearedSound

@onready var cursor: Node2D = $cursor
@onready var look_at_cursor: Node2D = $LookAtCursor
@onready var shoot_pos: Marker2D = $LookAtCursor/ShootPos
@onready var shoot_timer: Timer = $ShootTimer
@onready var current_ammo_label: Label = $Ammo/CurrentAmmoLabel
@onready var skill_tree: Control = $SkillTree
@onready var flashlight: PointLight2D = $LookAtCursor/Flashlight
@onready var levels_animation_player: AnimationPlayer = $Levels
@onready var body: ProgressBar = $LookAtCursor/Body
@onready var anim_player: AnimationPlayer = $AnimationPlayer

var can_shoot: bool = true
var skill_tree_show: bool = false
var flashlight_show: bool = false

const BULLET_SCENE = preload("res://Scenes/Weapons/Bullet/bullet.tscn")

func _ready() -> void:
	
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	skill_tree_show = false
	
	Global.level_cleared.connect(level_cleared)
	Global.rapid_fire_used.connect(activate_rapid_fire)
	Global.ability_ended.connect(deactivate_rapid_fire)
	Global.teleport.connect(teleport)


func _physics_process(delta: float) -> void:
	if Global.can_move:
		var input_direction = Input.get_vector("left", "right", "up", "down")
		velocity = input_direction * player_speed
	
	cursor.global_position = get_global_mouse_position()
	look_at_cursor.look_at(cursor.global_position)
	
	if Global.ammo > 0:
		if Input.is_action_pressed("shoot") and can_shoot:
			_shoot()
			can_shoot = false
			shoot_timer.start()
	
	if Input.is_action_just_pressed("show_skill_tree"):
		skill_tree_show = !skill_tree_show
	
	if Input.is_action_just_pressed("flashlight"):
		flashlight_show = !flashlight_show
	
	if Input.is_action_just_pressed("show_mouse"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
	#if Global.at_base:
		#chords.play()
		#if chords.playing == true:
			#print("playing chords")
	
	Global.player_pos = Vector2(self.global_position.x, self.global_position.y)
	
	
	if flashlight_show:
		flashlight.show()
	else:
		flashlight.hide()
	
	
	
	body.max_value = Global.max_player_health
	body.value = Global.player_health
	
	Global.level_to_load = str("res://Scenes/Levels/level_", Global.current_level, ".tscn")
	
	if Global.enemies_in_current_level == Global.enemies_killed:
		if Global.can_clear_level:
			level_cleared()
	
	if Global.player_health <= 0:
		get_tree().change_scene_to_file("res://Scenes/Menus/death_screen.tscn")
	if Global.player_health >= Global.max_player_health:
		Global.player_health = Global.max_player_health
		
	move_and_slide()


func _shoot():
	if !Global.in_menu:
		shoot_sound.play()
		var new_bullet = BULLET_SCENE.instantiate()
		new_bullet.global_position = shoot_pos.global_position
		new_bullet.global_rotation = shoot_pos.global_rotation
		get_parent().add_child(new_bullet)
		Global.ammo_changed.emit()
		Global.shoot.emit()
		if !Global.at_base:
			Global.ammo -= 1
		#if !rapid_fire:
			#ammo -= 1
		#Global.shoot.emit()
		#shooting_sfx.play()


func _on_shoot_timer_timeout() -> void:
	can_shoot = true


func _on_collectables_area_entered(area: Area2D) -> void:
	if area.is_in_group("ammo"):
		pickup_ammo_sound.play()
		Global.ammo_added.emit()
		Global.ammo += 15



func level_changed():
	levels_animation_player.play("level_1_entered")


func _on_button_pressed() -> void:
	match Global.current_level:
		1:
			levels_animation_player.play("level_1_entered_animation_end")

func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy_bullet"):
		anim_player.play("hit")
		Global.player_health -= 5
		Global.player_damaged.emit()

func level_cleared():
	level_cleared_sound.play()
	Global.can_clear_level = false

func activate_rapid_fire():
	if Global.attack_speed > 0.1:
		shoot_timer.wait_time = 0.1

func deactivate_rapid_fire():
	shoot_timer.wait_time = Global.attack_speed

func teleport():
	global_position = cursor.global_position
