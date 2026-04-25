extends Control

@onready var anim_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	hide()

func _physics_process(delta: float) -> void:
	test_esc()


func resume():
	Global.in_menu = false
	Global.paused = false
	get_tree().paused = false
	anim_player.play_backwards("in")

func pause():
	Global.in_menu = true
	Global.paused = true
	get_tree().paused = true
	anim_player.play("in")

func test_esc():
	if Input.is_action_just_pressed("pause"):
		if !get_tree().paused:
			show()
			pause()
		else:
			hide()
			resume()



func _on_resume_pressed() -> void:
	resume()
