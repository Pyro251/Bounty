extends Node2D

func _ready() -> void:
	$SubViewport/Label.text = str("- ", int(Global.attack_damage))
	$GPUParticles2D.emitting = true
