class_name EnemySpawner
extends Node2D

signal enemy_removed(enemy)
signal enemy_finished()
signal drop_finished()

@export var enemy_scene: PackedScene
@export var enemy_spawner_scene: PackedScene
@export var enemy_thrower_scene: PackedScene
@export var spawner_enemy_chance := 0.3
@export var throw_enemy_chance := 0.3

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
	enemy.spawn_enemy.connect(_spawn_projectile)
	_add_enemy_to_scene(enemy)

func _spawn_throw_enemy():
	var enemy = enemy_thrower_scene.instantiate() as TypedEnemyThrow
	enemy.spawn_enemy.connect(_spawn_projectile)
	_add_enemy_to_scene(enemy)

func _spawn_normal_enemy():
	var enemy = enemy_scene.instantiate()
	_add_enemy_to_scene(enemy)

func _spawn_projectile(pos: Vector2, res: EnemyResource):
	var node = enemy_scene.instantiate() as TypedEnemy
	node.enemy_res = res
	node.type = TypedEnemy.Type.PROJECTILE
	node.z_index = 50
	_add_enemy_to_scene(node, pos)

func _add_enemy_to_scene(enemy: TypedEnemy, pos = _random_position()):
	enemy.global_position = pos
	enemy.target = Vector2(0, pos.y)
	enemy.finished.connect(func(): enemy_finished.emit())
	enemy.dropped.connect(func(node):
		node.finished.connect(func(): drop_finished.emit())
		root.add_child(node)
	)
	root.add_child(enemy)

func get_available_enemies():
	return get_tree().get_nodes_in_group(TypedEnemy.ENEMY_GROUP).filter(func(x): return not x.is_finished)

func _random_position():
	var vp = get_viewport_rect().size
	var start = Vector2.ZERO + Vector2.RIGHT * vp.x
	var height = (vp.y - 20) / 2
	return start + Vector2.UP * randf_range(-height, height)
