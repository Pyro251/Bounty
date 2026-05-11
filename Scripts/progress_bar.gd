extends Control

@onready var money: Label = $MenuCamera/UI/Money
@onready var camera_2d: Camera2D = $Camera2D
@onready var tab_bar: TabBar = $TabBar
@onready var menu_cursor_1: Node2D = $MenuCursor1
@onready var menu_cursor_2: Node2D = $MenuCamera/UI/MenuCursor2

@onready var tabs: Control = $Tabs

@onready var tab_list: Array = tabs.get_children()

func _ready() -> void:
	for tab in tab_list:
		tab.hide()
	tab_list[0].show()

func _process(delta: float) -> void:
	money.text = str("MONEY: ", Global.player_money)

func _on_quit_pressed() -> void:
	save()
	get_tree().change_scene_to_file("res://Scenes/Levels/base.tscn")

func save():
	SaveLoad._set_save_data()
	SaveLoad._save()


@onready var previous_tab = 0
func _on_tab_bar_tab_selected(tab: int) -> void:
	tab_list[previous_tab].hide()
	tab_list[tab].show()
	previous_tab = tab


func _on_bottom_panel_mouse_entered() -> void:
	menu_cursor_1.hide()
	menu_cursor_2.show()


func _on_bottom_panel_mouse_exited() -> void:
	menu_cursor_1.show()
	menu_cursor_2.hide()


func _on_tab_bar_mouse_entered() -> void:
	menu_cursor_1.hide()
	menu_cursor_2.show()
