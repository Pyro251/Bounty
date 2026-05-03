extends Control

@onready var click_sound: AudioStreamPlayer = $Click
@onready var blip: AudioStreamPlayer = $Blip
@onready var resolution_dropdown: OptionButton = $TabContainer/TabBar/VBoxContainer/HBoxContainer2/ResolutionDropdown

@onready var master_volume: HSlider = $TabContainer/TabBar3/MasterVolume
@onready var music_volume: HSlider = $TabContainer/TabBar3/MusicVolume
@onready var ui_volume: HSlider = $TabContainer/TabBar3/UIVolume
@onready var enemies_volume: HSlider = $TabContainer/TabBar3/EnemiesVolume
@onready var projectiles_volume: HSlider = $TabContainer/TabBar3/ProjectilesVolume
@onready var collectables_volume: HSlider = $TabContainer/TabBar3/CollectablesVolume

func _ready() -> void:
	master_volume.value = SaveLoad.save_data.master_audio
	music_volume.value = SaveLoad.save_data.music_audio
	ui_volume.value = SaveLoad.save_data.ui_audio
	enemies_volume.value = SaveLoad.save_data.enemies_audio
	projectiles_volume.value = SaveLoad.save_data.projectiles_audio
	collectables_volume.value = SaveLoad.save_data.collectables_audio
	
	add_resolutions()
	
	hide()

func add_resolutions():
	for r in Global.resolutions:
		resolution_dropdown.add_item(r)

func update_resolution_value():
	var window_size_string = str(get_window().size.x, "x", get_window().size.y)
	var res_index = Global.resolutions.keys().find(window_size_string)
	resolution_dropdown.selected = res_index

func _on_done_pressed() -> void:
	click_sound.play()
	SaveLoad._save()
	hide()


func _on_master_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))
	SaveLoad.save_data.master_audio = value


func _on_music_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))
	SaveLoad.save_data.music_audio = value


func _on_ui_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("UI"), linear_to_db(value))
	SaveLoad.save_data.ui_audio = value


func _on_enemies_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Enemies"), linear_to_db(value))
	SaveLoad.save_data.enemies_audio = value


func _on_projectiles_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Projectiles"), linear_to_db(value))
	SaveLoad.save_data.projectiles_audio = value


func _on_collectables_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Collectables"), linear_to_db(value))
	SaveLoad.save_data.collectables_audio = value


func _on_done_mouse_entered() -> void:
	blip.play()


func _on_resolution_dropdown_item_selected(index: int) -> void:
	var key = resolution_dropdown.get_item_index(index)
	get_window().set_size(Global.resolutions[key])
