extends Camera3D

const FIRST = preload("res://games/build-scale/levels/level_1.tscn")
const LEVELS = [
	FIRST,
]

@export var coin_spawner: CoinSpawner
@export var hp_label: Label
@export var coin_label: Label

@export var offset_y := -3

@export var max_health := 3
@onready var health := max_health:
	set(v):
		health = v
		hp_label.text = "%s" % v

var coins := 0:
	set(v):
		coins = v
		coin_label.text = "%s" % v

var follow_target: Coin
var last_spawned := Vector3.ZERO

var level_flip = {}

func _ready() -> void:
	self.health = max_health
	self.coins = 0
	
	_init_level()
	follow_target = spawn_new_coin()
	setup_target()

func _init_level():
	_spawn_level(Vector3.ZERO, FIRST)

func _spawn_level(pos = Vector3.ZERO, scene: PackedScene = LEVELS.pick_random()):
	last_spawned = pos
	
	var level_id = scene.resource_path
	if not level_id in level_flip:
		level_flip[level_id] = false
	else:
		level_flip[level_id] = not level_flip[level_id]
	
	var lvl = scene.instantiate() as CoinLevel
	lvl.pos = pos
	lvl.flipped = level_flip[level_id]
	lvl.spawn_next.connect(func(pos):
		if pos.y < last_spawned.y:
			_spawn_level(pos)
	)
	get_tree().current_scene.call_deferred("add_child", lvl)

func spawn_new_coin():
	var spawn = coin_spawner
	return spawn.spawn()

func setup_target():
	follow_target.deadend_reached.connect(func(): _reset_coin())
	follow_target.left_screen.connect(func(): _reset_coin())
	follow_target.picked_up.connect(func(item):
		match item:
			ItemResource.Type.Health:
				health += 1
				if health > max_health:
					health = max_health
			ItemResource.Type.Coin:
				coins += 1
	)

func _reset_coin():
	if is_instance_valid(follow_target):
		follow_target.queue_free()
	follow_target = spawn_new_coin()
	setup_target()

func _process(delta: float) -> void:
	if is_instance_valid(follow_target) and is_inside_tree():
		global_position.y = follow_target.global_position.y + offset_y
