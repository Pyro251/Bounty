extends CanvasLayer

@onready var current_ammo: Label = $CurrentAmmo
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var current_money_label: Label = $CurrentMoney
@onready var gain_coin_sound: AudioStreamPlayer = $GainCoinSound
@onready var money_anim: AnimationPlayer = $MoneyAnim
@onready var current_location: Label = $CurrentLocation

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


func ammo_changed():
	animation_player.play("change_ammo_1")

func ammo_added():
	animation_player.play("add_ammo_1")

func money_added():
	gain_coin_sound.play()
	money_anim.play("add_money_1")
