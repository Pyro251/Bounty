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

# abilities
signal ability_ended
signal rapid_fire_used

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
var attack_damage: float

var enemies_in_current_level: int
var enemies_killed: int = 0
var can_clear_level: bool = true

var ability_cooldown: float = 5.0
