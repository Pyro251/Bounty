extends Node2D

@onready var ready_up: ProgressBar = $ReadyUp
@onready var ready_up_timer: Timer = $ReadyUpTimer
@onready var ready_up_sound: AudioStreamPlayer = $ReadyUpSound
@onready var ready_up_end_sound: AudioStreamPlayer = $ReadyUpEndSound

@export var target_value = 100
@export var ready_up_speed = 0.4

var in_area: bool = false

const BEGGINING_VALUE: int = 0

func _ready() -> void:
	Global.can_clear_level = true

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
