extends CanvasLayer

@onready var current_ammo: Label = $CurrentAmmo
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var current_money_label: Label = $CurrentMoney
@onready var gain_coin_sound: AudioStreamPlayer = $GainCoinSound
@onready var money_anim: AnimationPlayer = $MoneyAnim
@onready var current_location: Label = $CurrentLocation
@onready var abilitiy_bar: ProgressBar = $AbilitiyCooldownBar
@onready var abiltiy_cooldown_timer: Timer = $AbiltiyCooldownTimer
@onready var time_left_in_ability_timer: Timer = $TimeLeftInAbilityTimer
@onready var time_left_in_ability_bar: ProgressBar = $TimeLeftInAbilityBar
@onready var teleport_timer: Timer = $TeleportTimer
@onready var teleport_bar: ProgressBar = $TeleportBar
@onready var teleport_anim: AnimationPlayer = $TeleportAnim
@onready var cooldown_done_anim: AnimationPlayer = $CooldownDoneAnim

var can_use_ability: bool = true
var using_ability_bar: bool = false
var using_teleport_bar: bool = false

func _ready() -> void:
	Global.ammo_changed.connect(ammo_changed)
	Global.ammo_added.connect(ammo_added)
	#Global.enemy_killed.connect(money_added)
	Global.money_collected.connect(money_added)


func _process(delta: float) -> void:
	
	current_ammo.text = str(Global.current_ammo)
	current_money_label.text = str(Global.player_money)
	
	if Global.at_base:
		current_location.text = str("HOME BASE")
	else:
		current_location.text = str("LEVEL ", Global.current_level)
	
	if using_ability_bar:
		abilitiy_bar.value = abiltiy_cooldown_timer.time_left
	else:
		abilitiy_bar.value = abilitiy_bar.max_value
	
	time_left_in_ability_bar.value = time_left_in_ability_timer.time_left
	
	if using_teleport_bar:
		teleport_bar.value = teleport_timer.time_left
	else:
		teleport_bar.value = teleport_bar.max_value
	
	if Input.is_action_just_pressed("ability"):
		if can_use_ability:
			using_ability_bar = true
			Global.using_ability = true
			can_use_ability = false
			time_left_in_ability_timer.start()
			abiltiy_cooldown_timer.start()
			Global.rapid_fire_used.emit()
	
	if Input.is_action_just_pressed("dash_teleport"):
		if Global.can_teleport:
			using_teleport_bar = true
			Global.teleport.emit()
			teleport_timer.start()
			Global.can_teleport = false
	
	if Global.using_ability:
		time_left_in_ability_bar.show()
	else:
		time_left_in_ability_bar.hide()


func ammo_changed():
	animation_player.play("change_ammo_1")

func ammo_added():
	animation_player.play("add_ammo_1")

func money_added():
	gain_coin_sound.play()
	money_anim.play("add_money_1")


func _on_abiltiy_cooldown_timer_timeout() -> void:
	using_ability_bar = false
	cooldown_done_anim.play("ready")
	can_use_ability = true


func _on_time_left_in_ability_timer_timeout() -> void:
	Global.ability_ended.emit()
	Global.using_ability = false


func _on_teleport_timer_timeout() -> void:
	using_teleport_bar = false
	teleport_anim.play("ready")
	Global.can_teleport = true
