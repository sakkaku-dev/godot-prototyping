class_name Gameover
extends Control

@export var coins: Label
@export var double_coins: Label
@export var divide_coins: Label
@export var total_coins: Label
@export var button: Button

func _ready() -> void:
	hide()
	button.pressed.connect(func():
		SceneManager.reload_scene()
	)

func show_coins(coin: Coin, died = false):
	get_tree().paused = true
	
	if died:
		coins.hide()
		double_coins.hide()
		divide_coins.hide()
		total_coins.hide()
	
	coins.text = "Collected coins: %s" % coin.coins
	double_coins.text = "Multiplier: %s" % coin.multiplier
	divide_coins.text = "Divier: %s" % coin.divider
	total_coins.text = "Total Coins: %s" % coin.get_total_coins()
	show()
	
	button.grab_focus()
