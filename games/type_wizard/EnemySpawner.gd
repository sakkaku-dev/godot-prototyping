extends Node2D

signal enemy_removed(enemies_left)
signal enemy_finished()

@export var enemy_scene: PackedScene
@export var enemy_spawner_scene: PackedScene
@export var spawner_enemy_chance := 0.3
@export var enemy_spawn_distance_from_player := 250

@export var data: DataManager
@export var root: Node2D

func spawn():
	if randf() < spawner_enemy_chance:
		_spawn_spawner_enemy()
	else:
		_spawn_normal_enemy()

func _spawn_spawner_enemy():
	var enemy = enemy_spawner_scene.instantiate() as TypedEnemySpawner
	enemy.set_word(data.get_random_spawner_enemy())
	enemy.spawn_enemy.connect(func(pos): _spawn_normal_enemy(data.get_random_projectile(), pos))
	enemy.global_position = _random_position()
	_add_enemy_to_scene(enemy)

func _spawn_normal_enemy(word = data.get_random_enemy(), pos = _random_position()):
	var enemy = enemy_scene.instantiate()
	enemy.set_word(word)
	enemy.global_position = pos
	_add_enemy_to_scene(enemy)

func _add_enemy_to_scene(enemy: TypedEnemy):
	enemy.finished.connect(func(): enemy_finished.emit())
	enemy.dropped.connect(func(node): root.add_child(node))
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
