extends Node2D


signal loaded


func _ready() -> void:
	Global.load_level.connect(load_level)

func _on_animation_player_animation_finished(Fill_bar):
	emit_signal("loaded")
	
	
func _on_animation_player_animation_finished_load(load_level):
	emit_signal("loaded")
	get_tree().change_scene_to_file(Global.level_to_load)
	
	

func _on_animation_player_animation_started(anim_name):
	$ProgressBar/Tone.play()
	$ProgressBar/CoolTone.play()
	
func _load():
	$ProgressBar/Tone.play()
	$ProgressBar/CoolTone.play()
	$ProgressBar/AnimationPlayer.play("Fill bar")
	
func load_level():
	$ProgressBar/Tone.play()
	$ProgressBar/CoolTone.play()
	$ProgressBar/AnimationPlayer.play("load_level")


func _on_child_entered_tree(node: Node) -> void:
	load_level()
