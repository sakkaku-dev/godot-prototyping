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

var coins := 0:
	set(v):
		coins = v

var follow_target: Coin
var last_spawned := Vector3.ZERO

var previous := ""
var level_flip = {}

func _ready() -> void:
	self.coins = 0
	
	goal.body_entered.connect(func():
		gameover.show_coins(follow_target)
	)
	
	#_init_level()
	follow_target = spawn_new_coin()
	setup_target()

#func _init_level():
	#_spawn_level(Vector3.ZERO, FIRST)
#
#func _random_level():
	#var lvls = LEVELS.duplicate().filter(func(r): return r.resource_path != previous)
	#return lvls.pick_random()
#
#func _spawn_level(pos = Vector3.ZERO, scene: PackedScene = _random_level()):
	#last_spawned = pos
	#
	#var level_id = scene.resource_path
	#if not level_id in level_flip:
		#level_flip[level_id] = false
	#else:
		#level_flip[level_id] = not level_flip[level_id]
	#previous = level_id
	#
	#var lvl = scene.instantiate() as CoinLevel
	#lvl.pos = pos
	#lvl.flipped = level_flip[level_id]
	#lvl.spawn_next.connect(func(pos):
		#if pos.y < last_spawned.y:
			#_spawn_level(pos)
	#)
	#get_tree().current_scene.call_deferred("add_child", lvl)

func spawn_new_coin():
	var spawn = coin_spawner
	return spawn.spawn()

func setup_target():
	follow_target.died.connect(func():
		gameover.show_coins(follow_target, true)
	)

func _reset_coin():
	if is_instance_valid(follow_target):
		follow_target.queue_free()
	follow_target = spawn_new_coin()
	setup_target()

func _process(delta: float) -> void:
	if is_instance_valid(follow_target) and is_inside_tree():
		global_position.y = follow_target.global_position.y + offset_y
