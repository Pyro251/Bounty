extends Control

# Misc
@onready var start_level_button: Button = $InsightPanel/StartLevel
@onready var close_ready_prep_sound: AudioStreamPlayer = $CloseReadyPrepSound
@onready var est_enemies: Label = $InsightPanel/VBoxContainer/EstimatedEnemies
@onready var est_difficulty: Label 
@onready var tutorial_root: Control = $InsightPanel/TutorialRoot

# Main
@onready var main_ability_description: RichTextLabel = $MainAbilityChoosingPanel/MainAbilityDescription
@onready var main_abilities_panel_anims: AnimationPlayer = $MainAbilitiesPanelAnims
@onready var main_ability_choosing_panel: Panel = $MainAbilityChoosingPanel
@onready var chosen_main_ability_anims: AnimationPlayer = $ChosenMainAbilityAnims
@onready var main_ability_button_anims: AnimationPlayer = $MainAbilityButtonAnims

# Secondary
@onready var secondary_ability_choosing_panel: Panel = $SecondaryAbilityChoosingPanel
@onready var secondary_ability_description: RichTextLabel = $SecondaryAbilityChoosingPanel/SecondaryAbilityDescription
@onready var secondary_ability_button_anims: AnimationPlayer = $SecondaryAbilityButtonAnims
@onready var secondary_abilities_panel_anims: AnimationPlayer = $SecondaryAbilitiesPanelAnims
@onready var chosen_secondary_ability_anims: AnimationPlayer = $ChosenSecondaryAbilityAnims

@export var rapid_fire_texture: Texture
@export var teleport_texture: Texture

const LOADING_SCREEN = preload("res://Scenes/Menus/loading_screen.tscn")
const ABILITY_BUTTON = preload("res://Scenes/Menus/ability_button.tscn")

func _ready() -> void:
	if Global.tutorial:
		start_level_button.hide()
		tutorial_root.show()
	else:
		start_level_button.show()
		tutorial_root.hide()
	
	Global.update_ability_description.connect(update_ability_description)
	Global.main_ability_selected.connect(main_ability_panel_out)
	Global.secondary_ability_selected.connect(secondary_ability_panel_out)
	
	Global.main_ability_selected_var = false
	Global.secondary_ability_selected_var = false
	
	# instanciates the correct amount of ability buttons
	
	# gets rid of all of the previous children, not really needed
	
	for child in get_node("MainAbilityChoosingPanel/GridContainer").get_children():
		child.queue_free()
		print("cleared main children")
	
	for child in get_node("SecondaryAbilityChoosingPanel/GridContainer").get_children():
		child.queue_free()
		print("cleared secondary children")
	
	
	
	var main_values_array: Array = Global.selectable_main_abilities.values()
	var main_keys_array: Array = Global.selectable_main_abilities.keys()
	
	for i in Global.selectable_main_abilities.size():
		if main_values_array.get(i):
			var new_ability_button = ABILITY_BUTTON.instantiate()
			
			get_node("MainAbilityChoosingPanel/GridContainer").add_child(new_ability_button)
			
			new_ability_button.main_ability = true
			
			new_ability_button.ability = str(main_keys_array.get(i))
			new_ability_button.ability_button_text = Global.main_ability_descriptions.get(i)
			
			new_ability_button.texture = get(str(new_ability_button.ability, "_texture"))
	
	# the below is the refactored code for the code above, work in progress
	
	#for key in Global.selectable_main_abilities:
		#if Global.selectable_main_abilities[key]:
			#var new_ability_button = ABILITY_BUTTON.instantiate()
			#
			#get_node("MainAbilityChoosingPanel/GridContainer").add_child(new_ability_button)
			#
			#new_ability_button.main_ability = true
			#
			#new_ability_button.ability = str(key)
			#new_ability_button.ability_button_text = Global.main_ability_descriptions.get(key)
			#
			#new_ability_button.texture = get(str(new_ability_button.ability, "_texture"))
	
	var secondary_values_array: Array = Global.selectable_secondary_abilities.values()
	var secondary_keys_array: Array = Global.selectable_secondary_abilities.keys()
	
	for i in Global.selectable_secondary_abilities.size():
		if secondary_values_array.get(i):
			var new_ability_button = ABILITY_BUTTON.instantiate()
			
			get_node("SecondaryAbilityChoosingPanel/GridContainer").add_child(new_ability_button)
			
			new_ability_button.secondary_ability = true
			
			new_ability_button.ability = str(secondary_keys_array.get(i))
			new_ability_button.ability_button_text = Global.secondary_ability_descriptions.get(i)
			
			new_ability_button.texture = get(str(new_ability_button.ability, "_texture"))
	
	Global.update_ability_button_texture.emit()

func _physics_process(delta: float) -> void:
	#line below doesn't quite work yet, attempting to make the label match enemies in the next level
	est_enemies.text = str("Estimated Enemies:", Global.enemies_in_current_level)
	start_level_button.text = str("START LEVEL ", Global.current_level, "?")
	
	if Global.main_ability_selected_var and Global.secondary_ability_selected_var:
		$InsightPanel/StartLevel.disabled = false
	else:
		$InsightPanel/StartLevel.disabled = true

func _on_play_pressed() -> void:
	Global.at_base = false
	Global.load_level.emit()
	get_tree().change_scene_to_file("res://Scenes/Menus/loading_screen.tscn")

func purchace_ammo():
	if Global.player_money >= 50:
		Global.player_money -= 50
		Global.ammo += 10
		Global.ammo_added.emit()

func _on_cancel_pressed() -> void:
	close_ready_prep_sound.play()
	Global.close_run_settings.emit()
	Global.show_player_ui.emit()
	print("loading:", Global.level_to_load)
	print("Current Level: ", Global.current_level)
	Global.in_menu = false
	Global.at_base = false


func _on_purchase_ammo_pressed() -> void:
	purchace_ammo()


func _on_tutorial_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/Tutorial/tutorial_level.tscn")
	Global.in_tutorial = true
	Global.in_menu = false
	Global.at_base = false

func _on_skip_pressed() -> void:
	tutorial_root.hide()
	start_level_button.show()
	Global.tutorial = false

func update_ability_description():
	main_ability_description.text = Global.main_ability_description
	secondary_ability_description.text = Global.secondary_ability_description

func main_ability_panel_out():
	main_abilities_panel_anims.play("out")
	main_ability_button_anims.play("out")
	chosen_main_ability_anims.play("in")
	$ChosenMainAbilityPanel.show()

func secondary_ability_panel_out():
	secondary_abilities_panel_anims.play("out")
	secondary_ability_button_anims.play("out")
	chosen_secondary_ability_anims.play("in")
	$ChosenSecondaryAbilityPanel.show()

func _on_choose_main_ability_button_pressed() -> void:
	main_ability_choosing_panel.show()
	main_abilities_panel_anims.play("in")

func _on_choose_secondary_ability_button_pressed() -> void:
	secondary_ability_choosing_panel.show()
	secondary_abilities_panel_anims.play("in")
