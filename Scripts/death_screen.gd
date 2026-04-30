extends Control

@onready var funny_haha: Label = $Funny_haha

func _ready() -> void:
	var random_num = randi_range(1,5)
	
	match random_num:
		1:
			funny_haha.text = str("you    suuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuck")
		2:
			funny_haha.text = str("Maybe  don't  get hit  by  the  bullets..?")
		3:
			funny_haha.text = str("Try  better  next  time.   Or  don't.  I  really  don't  care")
		4:
			funny_haha.text = str("this  is  the  opposite  of   'happily  ever  after'")
		5:
			funny_haha.text = str("that  was  kinda  disapointing")

func _on_load_from_last_save_button_pressed() -> void:
	SaveLoad._load()
	SaveLoad._set_load_data()
	get_tree().change_scene_to_file("res://Scenes/Levels/base.tscn")


func _on_quit_to_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menus/main_menu.tscn")
