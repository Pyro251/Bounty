extends Node


signal ammo_changed
signal ammo_added
signal level_changed
signal open_run_settings
signal close_run_settings
signal hide_player_ui
signal show_player_ui
signal enemy_killed
signal player_damaged
signal level_cleared
signal trigger_camera_shake
signal shoot
signal money_collected
signal teleport
signal load_level
signal game_saved
signal explode_player
signal bullet_exploded
signal health_collected
signal mission_selected
signal trigger_boss
signal update_ability_description
signal update_ability_button_texture
signal main_ability_selected
signal secondary_ability_selected

# abilities
signal ability_ended
signal rapid_fire_used

var game_type: Dictionary = {
	"action_packed": false,
	"campaign": false,
	"speed_run": false
}

var resolutions = {
	"3840x2160": Vector2i(3840,2160),
	"2560x1440": Vector2i(2560,1440),
	"1920x1080": Vector2i(1920,1080),
	"1366x768": Vector2i(1366,768),
	"1280x720": Vector2i(1280,720),
	"1440x900": Vector2i(1440,900),
	"1600x900": Vector2i(1600,900),
	"1024x600": Vector2i(1024,600),
	"800x600": Vector2i(800,600)
}

#abilities

#var health1: int = 0
#var health2: int = 0
#var regen1: int = 0
#var attack1: int = 0
#var attack2: int = 0
#var attack_speed1: int = 0

#var unlocked_main_abilities_count: int = 1
#var unlocked_secondary_abilities_count: int = 1



var main_ability_selected_var: bool = false
var secondary_ability_selected_var: bool = false

var main_ability_description: String
var secondary_ability_description: String



#class Ability:
	#var description: String
	#var selectable: bool
#
#func _init





var abilities_nested: Dictionary = {
	"main": {
		"names": {
			"rapid_fire": "Rapid Fire"
		},
		"descriptions": {
			"rapid_fire": "RAPID FIRE, increases firing speed of your gun. Gives you five ammo."
		},
		"selectable": {
			"rapid_fire": true
		},
		"selected": {
			"rapid_fire": false
		}
	},
	
	"secondary": {
		"names": {
			"teleport": "Teleport",
			"shockwave": "Shockwave"
		},
		"descriptions": {
			"teleport": "TELEPORT, telports you to the position of your mouse cursor.",
			"shockwave": "SHOCKWAVE, releases a shockwave from your current location."
		},
		"selectable": {
			"teleport": true,
			"shockwave": false
		},
		"selected": {
			"teleport": false,
			"shockwave": false
		}
	}
}

#var secondary_abilities_nested: Dictionary = {
	#"names": {
		#"teleport": "Teleport",
		#"shockwave": "Shockwave"
	#},
	#"descriptions": {
		#"teleport": "TELEPORT, telports you to the position of your mouse cursor.",
		#"shockwave": "SHOCKWAVE, releases a shockwave from your current location."
	#},
	#"selectable": {
		#"teleport": true,
		#"shockwave": false
	#},
	#"selected": {
		#"teleport": false,
		#"shockwave": false
	#}
#}

#var main_ability_descriptions: Array = [
	#"RAPID FIRE, increases firing speed of your gun. Gives you five ammo."
#]
#var secondary_ability_descriptions: Array = [
	#"TELEPORT, telports you to the position of your mouse cursor.",
	#"SHOCKWAVE, releases a shockwave from your current location."
#]
#
#
#var selectable_main_abilities: Dictionary = {
	#"rapid_fire": true
#}
#var selectable_secondary_abilities: Dictionary = {
	#"teleport": true,
	#"shockwave": false
#}


var abilities: Dictionary = {
	
}


var recurrence_unlocked: bool = false


var enable_tooltips: bool = true
var tooltips: Dictionary = {
	"target_dummy" = true
}

var current_ability: String
var using_ability: bool = false
var can_teleport: bool = true

var player_pos
var player_color: Color

var chest_in_anim: bool = true

var ammo: int = 20
var bullet_damage = 20
var bullet_explosion_chance: int = 0
var bullet_explosion_radius: float = 1.0

var in_menu: bool = false
var at_base: bool = true
var tutorial: bool = true
var in_tutorial: bool = false
var in_dialogue: bool = false
var can_move: bool = true
var paused: bool = false
var show_changes: bool = true
var in_boss_level: bool = false

var mission_selected_var: bool = false
var show_alert: bool = true

var current_level: int = 1
var level_to_load

var player_money: int = 0
var money_made_this_level: int = 0
var money_per_drop: int = 15

var player_health: float = 15.0
var enemy_damage: float = 5.0
var max_player_health: float = 15.0
var regen_health: int = 0
var health_per_enemy_health_collectable: int = 1
var attack_speed: float = 0.25
var attack_damage: float = 20

var enemies_in_current_level: int
var enemies_killed: int = 0
var can_clear_level: bool = true

var ability_cooldown: float = 5.0

var mission_panel_text: String
