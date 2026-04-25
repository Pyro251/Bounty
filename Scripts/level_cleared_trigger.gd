extends ProgressBar

@onready var level_cleared_trigger: ProgressBar = $"."
@onready var ready_up_timer: Timer = $ReadyUpTimer
@onready var ready_up_sound: AudioStreamPlayer = $ReadyUpSound
@onready var ready_up_end_sound: AudioStreamPlayer = $ReadyUpEndSound
@onready var level_trigger_cancel_sound: AudioStreamPlayer = $LevelTriggerCancelSound

var in_area: bool = false
var can_extract: bool = true

func _physics_process(delta: float) -> void:
	
	if in_area:
		level_cleared_trigger.value = ready_up_timer.time_left
	else:
		level_cleared_trigger.value = 1
	
	if Global.enemies_in_current_level == Global.enemies_killed:
		can_extract = true
	else:
		can_extract = false

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("player"):
		in_area = false
		ready_up_timer.stop()
		ready_up_sound.stop()
		ready_up_end_sound.play()


func _on_ready_up_timer_timeout() -> void:
	can_extract = false
	Global.at_base = true
	get_tree().change_scene_to_file("res://Scenes/Menus/level_cleared_screen.tscn")


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		if can_extract:
			in_area = true
			ready_up_timer.start()
			ready_up_sound.play()
		else:
			level_trigger_cancel_sound.play()
			Global.trigger_camera_shake.emit()
