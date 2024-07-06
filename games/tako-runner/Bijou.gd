extends CharacterBody2D

enum Attack {
	STONE_PLATES,
	STONE_THROW,
	STONE_FALL,
}

@export var speed := 250
@export var obstacles: Array[PackedScene] = []
@export var attack_area: Area2D
@export var attack_timer: Timer
@export var attack_offset := 300

@export_category("Stone Plate")
@export var stone_plate: PackedScene
@export var stone_plate_count := 3
@export var spawn_time_diff := 0.5
@export var spawn_distance_diff := 100

@export_category("Stone Throw")
@export var stone_throw: PackedScene
@export var stone_throw_count := 3
@export var throw_spawn_time_diff := 0.7
@export var throw_attack_wait_time := 0.5

@export_category("Stone Fall")
@export var stone_fall: PackedScene
@export var stone_fall_count := 2
@export var stone_fall_spawn_time_diff := 3.0

var is_attacking := false
var player: Player

func _ready():
	attack_area.body_entered.connect(func(_b): _attack())
	attack_timer.timeout.connect(func(): _attack())

func _physics_process(delta: float):
	velocity = Vector2.RIGHT * speed
	move_and_slide()

func _attack():
	var atk = Attack.values().pick_random()
	
	var players = attack_area.get_overlapping_bodies()
	if players.is_empty() or is_attacking:
		return

	print("Attack %s" % Attack.keys()[atk])
	player = players[0]
	var pos = Vector2(player.global_position.x, 0) + Vector2.RIGHT * attack_offset
	
	is_attacking = true
	match atk:
		Attack.STONE_PLATES: _spawn_stone_plates(pos)
		Attack.STONE_THROW: _spawn_stone_throw()
		Attack.STONE_FALL: _spawn_stone_fall()
	
func _spawn_stone_plates(pos: Vector2):
	for i in stone_plate_count:
		spawn(pos + Vector2.RIGHT * spawn_distance_diff * i, stone_plate)
		await get_tree().create_timer(spawn_time_diff).timeout
	
	_finish_attack()

func _spawn_stone_fall():
	for i in stone_fall_count:
		spawn(Vector2(player.global_position.x, 0) + Vector2.RIGHT * attack_offset, stone_fall)
		await get_tree().create_timer(stone_fall_spawn_time_diff).timeout
	
	_finish_attack()

func _spawn_stone_throw():
	var stones = []
	for i in stone_throw_count:
		var node = stone_throw.instantiate()
		node.center_node = self
		stones.append(node)
		get_tree().current_scene.call_deferred("add_child", node)
		await get_tree().create_timer(throw_spawn_time_diff).timeout
		
	await get_tree().create_timer(1.0).timeout
	for stone in stones:
		stone.attack(player)
		await stone.hit
		await get_tree().create_timer(throw_attack_wait_time).timeout
	
	_finish_attack()

func _finish_attack():
	is_attacking = false
	attack_timer.start()

func spawn(pos: Vector2, scene: PackedScene):
	var node = scene.instantiate()
	node.global_position = pos
	get_tree().current_scene.call_deferred("add_child", node)
