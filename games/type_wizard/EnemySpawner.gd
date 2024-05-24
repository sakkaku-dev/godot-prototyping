class_name EnemySpawner
extends Node2D

signal enemy_removed(enemies_left)
signal enemy_finished()
signal drop_finished()

@export var enemy_scene: PackedScene
@export var enemy_spawner_scene: PackedScene
@export var enemy_thrower_scene: PackedScene
@export var spawner_enemy_chance := 0.3
@export var throw_enemy_chance := 0.3
@export var enemy_spawn_distance_from_player := 250

@export var data: DataManager
@export var root: Node2D

func spawn():
	var r = randf()
	if r < spawner_enemy_chance:
		_spawn_spawner_enemy()
	elif r < spawner_enemy_chance + throw_enemy_chance:
		_spawn_throw_enemy()
	else:
		_spawn_normal_enemy()

func _spawn_spawner_enemy():
	var enemy = enemy_spawner_scene.instantiate() as TypedEnemySpawner
	enemy.set_word(data.get_random_spawner_enemy())
	enemy.spawn_enemy.connect(_spawn_projectile)
	_add_enemy_to_scene(enemy)

func _spawn_throw_enemy():
	var enemy = enemy_thrower_scene.instantiate() as TypedEnemyThrow
	enemy.set_word(data.get_random_throw_enemy())
	enemy.spawn_enemy.connect(_spawn_projectile)
	_add_enemy_to_scene(enemy)

func _spawn_normal_enemy(word = data.get_random_enemy()):
	var enemy = enemy_scene.instantiate()
	enemy.set_word(word)
	_add_enemy_to_scene(enemy)

func _spawn_projectile(pos: Vector2, res: EnemyResource):
	var node = enemy_scene.instantiate() as TypedEnemy
	node.enemy_res = res
	node.set_word(data.get_random_projectile())
	node.z_index = 50
	_add_enemy_to_scene(node, pos)

func _add_enemy_to_scene(enemy: TypedEnemy, pos = _random_position()):
	enemy.global_position = pos
	enemy.finished.connect(func(): enemy_finished.emit())
	enemy.dropped.connect(func(node):
		node.finished.connect(func(): drop_finished.emit())
		root.add_child(node)
	)
	enemy.removed.connect(func():
		var enemies = get_tree().get_nodes_in_group(TypedEnemy.ENEMY_GROUP)
		enemies.erase(enemy)
		enemy_removed.emit(enemies)
	)
	root.add_child(enemy)

func get_available_enemies():
	return get_tree().get_nodes_in_group(TypedEnemy.ENEMY_GROUP).filter(func(x): return not x.is_finished)

func _random_position():
	return (Vector2.RIGHT * enemy_spawn_distance_from_player).rotated(randf_range(0, TAU))
