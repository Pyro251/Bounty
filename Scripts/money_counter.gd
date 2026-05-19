extends Node2D


func _ready() -> void:
	$SubViewport/Label.text = str("+ ", int(Global.money_per_drop))
	$GPUParticles2D.emitting = true
	print("money counter added")
