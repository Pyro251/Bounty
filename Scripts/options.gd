extends Control

@onready var tab_bar: TabBar = $TabBar
@onready var click_sound: AudioStreamPlayer = $Click

# Panels
@onready var panel_1: ColorRect = $Panel1
@onready var panel_2: ColorRect = $Panel2
@onready var panel_3: ColorRect = $Panel3

func _ready() -> void:
	hide()
	tab_bar.current_tab = 0
	panel_1.show()

func _physics_process(delta: float) -> void:
	
	match tab_bar.current_tab:
		0:
			panel_1.show()
			panel_2.hide()
			panel_3.hide()
		1:
			panel_1.hide()
			panel_2.show()
			panel_3.hide()
		2:
			panel_1.hide()
			panel_2.hide()
			panel_3.show()


func _on_done_pressed() -> void:
	click_sound.play()
	hide()
