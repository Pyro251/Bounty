extends Camera2D

@onready var ui: CanvasLayer = $UI

var zoom_speed = 0.1
var min_zoom = 0.5
var max_zoom = 2.0
var zoom_target = zoom.x

var is_pressed = false

func _unhandled_input(event: InputEvent) -> void:
	
	if event.is_action_pressed("zoom_out"):
		zoom_target = clamp(zoom_target - zoom_speed, min_zoom, max_zoom)
	elif event.is_action_pressed("zoom_in"):
		zoom_target = clamp(zoom_target + zoom_speed, min_zoom, max_zoom)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and is_pressed:
		global_position -= event.relative
		print(event.relative)
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MIDDLE:
			is_pressed = event.pressed


func _process(delta):
	# Smoothly interpolate zoom
	zoom.x = lerp(zoom.x, zoom_target, 0.2)
	zoom.y = lerp(zoom.y, zoom_target, 0.2)
