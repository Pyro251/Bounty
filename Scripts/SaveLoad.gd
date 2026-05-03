extends Node

const SAVE_LOCATION = "user://SaveFile.json"

var save_data: Dictionary = {
	"current_level": 1,
	"player_health": 100.0,
	"player_money": 100,
	"show_changes": true,
	
	# research tree
	"health1": 0,
	"health2": 0,
	"regen1": 0,
	"attack1": 0,
	"attack2": 0,
	"attack_speed1": 0,
	
	# audio settings
	"master_audio": 1.0,
	"music_audio": 1.0,
	"ui_audio": 1.0,
	"enemies_audio": 1.0,
	"projectiles_audio": 1.0,
	"collectables_audio": 1.0,
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
	save_data.health2 = Global.health2
	save_data.regen1 = Global.regen1
	save_data.attack1 = Global.attack1
	save_data.attack2 = Global.attack2
	save_data.attack_speed1 = Global.attack_speed1

func _load():
	if FileAccess.file_exists(SAVE_LOCATION):
		var file = FileAccess.open(SAVE_LOCATION, FileAccess.READ)
		var data: Dictionary = file.get_var()
		
		for i in data:
			if save_data.has(i):
				save_data[i] = data[i]
		
		file.close()
		
		print("Game Loaded")

func _set_load_data():
	Global.current_level = save_data.current_level
	Global.player_health = save_data.player_health
	Global.player_money = save_data.player_money
	Global.show_changes = save_data.show_changes
	
	
	#abilities
	Global.health1 = save_data.health1
	Global.health2 = save_data.health2
	Global.regen1 = save_data.regen1
	Global.attack1 = save_data.attack1
	Global.attack2 = save_data.attack2
	Global.attack_speed1 = save_data.attack_speed1

func _wipe_save():
	DirAccess.remove_absolute(SAVE_LOCATION)
