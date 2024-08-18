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

var coins := 0:
	set(v):
		coins = v

var follow_target: Coin
var last_spawned := Vector3.ZERO

var previous := ""
var level_flip = {}

func _ready() -> void:
	self.coins = 0
	
	goal.body_entered.connect(func(a):
		gameover.show_coins(follow_target)
		bgm.stop()
		win.play()
	)
	
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

func _reset_coin():
	if is_instance_valid(follow_target):
		follow_target.queue_free()
	follow_target = spawn_new_coin()
	setup_target()

func _process(delta: float) -> void:
	if is_instance_valid(follow_target) and is_inside_tree():
		global_position.y = follow_target.global_position.y + offset_y
