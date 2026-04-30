extends Node

const SAVE_LOCATION = "user://SaveFile.json"

var save_data: Dictionary = {
	"current_level": 1,
	"player_health": 100.0,
	"player_money": 100,
	"show_changes": true,
	"health1": 0
}

func _ready() -> void:
	_load()


func _save():
	var file = FileAccess.open(SAVE_LOCATION, FileAccess.WRITE)
	file.store_var(save_data)
	file.close()
	print("Game Saved")

func _set_save_data():
	save_data.current_level = Global.current_level
	save_data.player_health = Global.player_health
	save_data.player_money = Global.player_money
	save_data.show_changes = Global.show_changes
	
	#abilities
	save_data.health1 = Global.health1

func _load():
	if FileAccess.file_exists(SAVE_LOCATION):
		var file = FileAccess.open(SAVE_LOCATION, FileAccess.READ)
		var data: Dictionary = file.get_var()
		
		for i in data:
			if save_data.has(i):
				save_data[i] = data[i]
		
		file.close()

func _set_load_data():
	Global.current_level = save_data.current_level
	Global.player_health = save_data.player_health
	Global.player_money = save_data.player_money
	Global.show_changes = save_data.show_changes
	
	#abilities
	Global.health1 = save_data.health1

func _wipe_save():
	DirAccess.remove_absolute(SAVE_LOCATION)
