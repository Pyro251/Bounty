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

# abilities
signal ability_ended
signal rapid_fire_used

var current_ability: String
var using_ability: bool = false
var can_teleport: bool = true

var player_pos

var chest_in_anim: bool = true

var current_ammo: int
var bullet_damage = 20

var in_menu: bool = false
var at_base: bool = true
var can_move: bool = true
var paused: bool = false

var current_level: int = 1
var level_to_load

var player_money: int = 0

var enemies_in_current_level: int
var enemies_killed: int = 0
var can_clear_level: bool = true

var ability_cooldown: float = 5.0
