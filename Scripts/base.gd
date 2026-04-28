extends Node2D

@onready var ready_up: ProgressBar = $ReadyUp
@onready var ready_up_timer: Timer = $ReadyUpTimer
@onready var ready_up_sound: AudioStreamPlayer = $ReadyUpSound
@onready var ready_up_end_sound: AudioStreamPlayer = $ReadyUpEndSound
@onready var on_loaded_sound: AudioStreamPlayer = $OnLoadedSound
@onready var level_prep: Control = $LevelPrep
@onready var ready_up_sound_2: AudioStreamPlayer = $ReadyUpSound2

@export var target_value = 100
@export var ready_up_speed = 0.4

var in_area: bool = false

const BEGGINING_VALUE: int = 0

func _ready() -> void:
	close_run_prep()
	on_loaded_sound.play()
	Global.can_clear_level = true
	Global.open_run_settings.connect(open_run_prep)
	Global.close_run_settings.connect(close_run_prep)
	Global.player_health = Global.max_player_health

func _physics_process(delta: float) -> void:
	if in_area:
		ready_up.value = ready_up_timer.time_left
	else:
		ready_up.value = 1

func _on_area_2d_area_entered(area: Area2D) -> void:
	in_area = true
	ready_up_timer.start()
	ready_up_sound.play()


func _on_area_2d_area_exited(area: Area2D) -> void:
	in_area = false
	ready_up_timer.stop()
	
	ready_up_sound.stop()
	ready_up_end_sound.play()
	
	Global.close_run_settings.emit()


func _on_ready_up_timer_timeout() -> void:
	Global.open_run_settings.emit()


func _on_loading_screen_loaded():
	pass # Replace with function body.




func open_run_prep():
	ready_up_sound_2.play()
	Global.hide_player_ui.emit()
	Global.in_menu = true
	level_prep.show()
	Global.can_move = false
	#Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func close_run_prep():
	Global.show_player_ui.emit()
	Global.in_menu = false
	level_prep.hide()
	Global.can_move = true
	#Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
