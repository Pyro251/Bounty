extends CharacterBody2D

@export var player_speed: float = 650.0

# Sounds
@onready var close_ready_prep_sound: AudioStreamPlayer = $Sounds/CloseReadyPrepSound
@onready var ready_up_sound_2: AudioStreamPlayer = $Sounds/ReadyUpSound2
@onready var shoot_sound: AudioStreamPlayer = $Sounds/ShootSound
@onready var pickup_ammo_sound: AudioStreamPlayer = $Sounds/PickupAmmoSound
@onready var level_cleared_sound: AudioStreamPlayer = $Sounds/LevelClearedSound

@onready var cursor: Node2D = $Cursor
@onready var look_at_cursor: Node2D = $LookAtCursor
@onready var shoot_pos: Marker2D = $LookAtCursor/ShootPos
@onready var shoot_timer: Timer = $ShootTimer
@onready var current_ammo_label: Label = $Ammo/CurrentAmmoLabel
@onready var skill_tree: Control = $SkillTree
@onready var flashlight: PointLight2D = $LookAtCursor/Flashlight
@onready var levels_animation_player: AnimationPlayer = $Levels
@onready var level_prep: Control = $LevelPrep
@onready var start_level_button: Button = $LevelPrep/Play
@onready var body: ProgressBar = $LookAtCursor/Body
@onready var anim_player: AnimationPlayer = $AnimationPlayer

var ammo: int = 20
var can_shoot: bool = true
var skill_tree_show: bool = false
var flashlight_show: bool = false
var health: int = 100

const BULLET_SCENE = preload("res://Scenes/Weapons/Bullet/bullet.tscn")

func _ready() -> void:
	
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	skill_tree_show = false
	
	close_run_prep()
	Global.open_run_settings.connect(open_run_prep)
	Global.close_run_settings.connect(close_run_prep)
	Global.level_cleared.connect(level_cleared)


func _physics_process(delta: float) -> void:
	
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * player_speed
	
	cursor.global_position = get_global_mouse_position()
	look_at_cursor.look_at(cursor.global_position)
	
	if ammo > 0:
		if Input.is_action_pressed("shoot") and can_shoot:
			_shoot()
			can_shoot = false
			shoot_timer.start()
	
	if Input.is_action_just_pressed("show_skill_tree"):
		skill_tree_show = !skill_tree_show
	
	if Input.is_action_just_pressed("flashlight"):
		flashlight_show = !flashlight_show
	
	
	Global.player_pos = Vector2(self.global_position.x, self.global_position.y)
	
	#if skill_tree_show:
		#skill_tree.show()
		#Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	#else:
		#skill_tree.hide()
		#Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	
	if flashlight_show:
		flashlight.show()
	else:
		flashlight.hide()
	
	Global.current_ammo = ammo
	
	start_level_button.text = str("START LEVEL ", Global.current_level, "?")
	body.value = health
	
	if Global.enemies_in_current_level == Global.enemies_killed:
		if Global.can_clear_level:
			level_cleared()
	
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
			ammo -= 1
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
		ammo += 15


func level_changed():
	levels_animation_player.play("level_1_entered")


func _on_button_pressed() -> void:
	match Global.current_level:
		1:
			levels_animation_player.play("level_1_entered_animation_end")


func open_run_prep():
	ready_up_sound_2.play()
	Global.hide_player_ui.emit()
	Global.in_menu = true
	level_prep.show()
	#Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func close_run_prep():
	Global.show_player_ui.emit()
	Global.in_menu = false
	level_prep.hide()
	#Input.mouse_mode = Input.MOUSE_MODE_HIDDEN


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file(Global.level_to_load)
	print("loading:", Global.level_to_load)
	Global.in_menu = false
	Global.at_base = false


func _on_cancel_pressed() -> void:
	close_ready_prep_sound.play()
	close_run_prep()


func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy_bullet"):
		anim_player.play("hit")
		health -= 5
		Global.player_damaged.emit()

func level_cleared():
	level_cleared_sound.play()
	Global.can_clear_level = false
