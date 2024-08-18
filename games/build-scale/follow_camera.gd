class_name CoinMachineGame
extends Camera3D

const FIRST = preload("res://games/build-scale/levels/level_1.tscn")
const LEVELS = [
	FIRST,
	preload("res://games/build-scale/levels/level_02.tscn"),
]

@export var coin_spawner: CoinSpawner
@export var goal: Area3D
@export var gameover: Gameover
@export var offset_y := -3

@onready var gameover_sound: AudioStreamPlayer = $GameoverSound
@onready var hurt: AudioStreamPlayer = $Hurt
@onready var start: AudioStreamPlayer = $Start
@onready var bgm: AudioStreamPlayer = $BGM
@onready var win: AudioStreamPlayer = $Win
@onready var coin_pickup: AudioStreamPlayer = $CoinPickup
@onready var multiplier_pickup: AudioStreamPlayer = $MultiplierPickup
@onready var down: AudioStreamPlayer = $Down

var follow_target: Coin

func _ready() -> void:
	get_tree().paused = false
	goal.body_entered.connect(func(a):
		gameover.show_coins(follow_target)
		bgm.stop()
		win.play()
	)
	
	start_game()

func start_game():
	await get_tree().create_timer(0.5).timeout
	follow_target = spawn_new_coin()
	setup_target()
	bgm.play()

func spawn_new_coin():
	start.play()
	var spawn = coin_spawner
	return spawn.spawn()

func setup_target():
	follow_target.died.connect(func():
		hurt.play()
		gameover_sound.play()
		gameover.show_coins(follow_target, true)
		bgm.stop()
	)
	follow_target.picked_up.connect(func(type):
		match type:
			ItemResource.Type.Coin:
				coin_pickup.play()
			ItemResource.Type.CoinDouble:
				multiplier_pickup.play()
			ItemResource.Type.EndCoinAdd:
				coin_pickup.play()
			ItemResource.Type.EndCoinDouble:
				multiplier_pickup.play()
			ItemResource.Type.CoinHole:
				down.play()
	)

func _reset_coin():
	if is_instance_valid(follow_target):
		follow_target.queue_free()
	follow_target = spawn_new_coin()
	setup_target()

func _process(delta: float) -> void:
	if is_instance_valid(follow_target) and is_inside_tree():
		var pos = follow_target.global_position.y + offset_y
		if pos >= -140:
			global_position.y = pos
