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
@onready var ability_anim: AnimationPlayer = $AbilityAnim
@onready var ammo_anim: AnimationPlayer = $AmmoAnim
@onready var letter_anim: AnimationPlayer = $LetterAnim

#music/sounds:
@onready var chords: AudioStreamPlayer = $music/Chords

var can_use_ability: bool = true
var using_ability_bar: bool = false
var using_teleport_bar: bool = false
var can_cooldown = false
var can_use_ability_anim = true

func _ready() -> void:
	Global.ammo_changed.connect(ammo_changed)
	Global.ammo_added.connect(ammo_added)
	#Global.enemy_killed.connect(money_added)
	Global.money_collected.connect(money_added)
	Global.can_teleport = true


func _process(delta: float) -> void:
	
	current_ammo.text = str(Global.current_ammo)
	current_money_label.text = str(Global.player_money)
	
	if Global.at_base:
		current_location.text = str("HOME BASE")
		

	
	else:
		current_location.text = str("LEVEL ", Global.current_level)

	
	if using_teleport_bar:
		teleport_bar.value = teleport_timer.time_left
	else:
		teleport_bar.value = teleport_bar.max_value
	
	if Input.is_action_just_pressed("ability"):
		if can_use_ability:
			Global.using_ability = true
			can_use_ability = false
			can_use_ability_anim = false
			ability_anim.play("use_ability")
			letter_anim.play("fade out")
			ammo_anim.play("ammo_down")
			$Ability.play()
			$Ability2.play()
			Global.rapid_fire_used.emit()
			print("ability used")
	if can_cooldown:
		ability_anim.play("cooldown")
		
		
		
	if Input.is_action_just_pressed("dash_teleport"):
		if Global.can_teleport:
			using_teleport_bar = true
			Global.teleport.emit()
			teleport_timer.start()
			Global.can_teleport = false
			$Teleport.play()
	

func ammo_changed():
	animation_player.play("change_ammo_1")

func ammo_added():
	animation_player.play("add_ammo_1")

func money_added():
	gain_coin_sound.play()
	money_anim.play("add_money_1")


	
	

func _on_teleport_timer_timeout() -> void:
	using_teleport_bar = false
	teleport_anim.play("ready")
	Global.can_teleport = true


func _on_ability_anim_animation_finished(use_ability):
	if !can_use_ability_anim:
		Global.ability_ended.emit()
		Global.using_ability = false
		can_cooldown = true
		$AbilityEnd.play()
		time_left_in_ability_bar.hide()
		print("ability bar finished")
		can_use_ability_anim = true

func _on_ability_anim_animation_finished_cooldown(cooldown):
	if can_cooldown:
		Global.ability_ended.emit()
		ability_anim.play("ready")
		can_use_ability = true
		time_left_in_ability_bar.show()
		letter_anim.play("fade in")
		ability_anim.play("RESET")
		$CooldownDoneAnim.play("ready")
		$Regen.play()
		ammo_anim.play("ammo_up")
		print("cooldown bar finished")
		can_cooldown = false
