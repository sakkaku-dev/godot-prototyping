class_name Gameover
extends Control

signal reached_num()

@export var coin_increase_speed := 20
@export var coins: Label
@export var double_coins: Label
@export var divide_coins: Label
@export var button: Button

@onready var money_sound: AudioStreamPlayer = $MoneySound

var target_num := 0.0
var current_num := 0.0:
	set(v):
		current_num = v
		coins.text = "%.0f" % v
		if not money_sound.playing:
			money_sound.play()
		if int(current_num) == int(target_num):
			current_num = target_num
			reached_num.emit()

func _ready() -> void:
	hide()
	self.current_num = 0
	button.pressed.connect(func(): SceneManager.reload_scene())

func _process(delta: float) -> void:
	if current_num != target_num:
		var diff = target_num - current_num
		if diff > 0:
			self.current_num += delta * coin_increase_speed * max((diff / 10), 1)
		else:
			self.current_num -= delta * coin_increase_speed * max(abs(diff / 10), 1)

func show_coins(coin: Coin, died = false):
	get_tree().paused = true
	
	double_coins.hide()
	divide_coins.hide()
	button.hide()
	
	show()
	target_num = coin.coins
	await reached_num
	
	double_coins.text = "x%s" % coin.multiplier
	double_coins.show()
	await get_tree().create_timer(0.5).timeout
	target_num = current_num * coin.multiplier
	if target_num != current_num:
		await reached_num
	else:
		await get_tree().create_timer(0.5).timeout
	double_coins.hide()
	
	divide_coins.text = "%%%s" % coin.divider
	divide_coins.show()
	await get_tree().create_timer(0.5).timeout
	target_num = current_num / coin.divider
	if target_num != current_num:
		await reached_num
	else:
		await get_tree().create_timer(0.5).timeout
	divide_coins.hide()
	
	#double_coins.text = "Multiplier: %s" % coin.multiplier
	#divide_coins.text = "Divier: %s" % coin.divider
	#total_coins.text = "Total Coins: %s" % coin.get_total_coins()
	
	await get_tree().create_timer(0.5).timeout
	button.show()
	button.grab_focus()
