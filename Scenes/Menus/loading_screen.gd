extends Node2D


signal loaded


func _on_animation_player_animation_finished(anim_name):
	emit_signal("loaded")
	


func _on_animation_player_animation_started(anim_name):
	$ProgressBar/Tone.play()
	$ProgressBar/CoolTone.play()
