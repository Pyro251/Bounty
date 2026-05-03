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

# abilities
signal ability_ended
signal rapid_fire_used

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
var health1: int = 0
var health2: int = 0
var regen1: int = 0
var attack1: int = 0
var attack2: int = 0
var attack_speed1: int = 0

var current_ability: String
var using_ability: bool = false
var can_teleport: bool = true

var player_pos

var chest_in_anim: bool = true

var ammo: int
var bullet_damage = 20

var in_menu: bool = false
var at_base: bool = true
var can_move: bool = true
var paused: bool = false
var show_changes: bool = true

var current_level: int = 1
var level_to_load

var player_money: int = 0
var money_made_this_level: int = 0

var player_health: float = 100.0
var max_player_health: float = 100.0
var health_per_enemy_health_collectable: int = 4
var attack_speed: float = 0.25
var attack_damage: float = 20

var enemies_in_current_level: int
var enemies_killed: int = 0
var can_clear_level: bool = true

var ability_cooldown: float = 5.0
