extends Area2D

@onready var anim_player: AnimationPlayer = $AnimPlayer

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "main"

var should_blink: bool = true

func _ready() -> void:
	anim_player.play("blink")

func _on_area_entered(area: Area2D) -> void:
	if should_blink:
		should_blink = false
		DialogueManager.show_example_dialogue_balloon(dialogue_resource, dialogue_start)
		modulate = Color(0.0, 0.643, 0.0, 1.0)


func _on_anim_player_animation_finished(anim_name: StringName) -> void:
	if should_blink:
		anim_player.play("blink")
