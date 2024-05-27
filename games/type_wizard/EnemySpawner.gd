class_name EnemySpawner
extends Node2D

signal enemy_removed(enemy)
signal enemy_finished(e)
signal drop_finished()

@export var enemy_scene: PackedScene
@export var enemy_spawner_scene: PackedScene
@export var enemy_thrower_scene: PackedScene
@export var spawner_enemy_chance := 0.3
@export var throw_enemy_chance := 0.3

@export var min_enemies := 4
@export var max_enemies := 10

@export var data: DataManager
@export var tile_map: TileMap

func spawn_enemies(player: Node2D):
	var enemies_pos = []
	
	var player_coord = tile_map.local_to_map(player.global_position)
	var tiles = _get_spawnable_tiles().filter(func(c): return Vector2(abs(c - player_coord)).length() > 2)
	if tiles.is_empty():
		return
	
	var count = randi_range(min_enemies, max_enemies)
	for i in range(count):
		var tile = tiles.pick_random()
		while enemies_pos.filter(func(c): Vector2(abs(c - tile)).length() <= 2).size() > 0 and not tiles.is_empty():
			tiles.erase(tile)
			tile = tiles.pick_random()
		
		enemies_pos.append(tile)
		
	for p in enemies_pos:
		_spawn(p)
	
	return count

func _get_spawnable_tiles():
	return tile_map.get_used_cells(0)

func _spawn(coord):
	var pos = tile_map.map_to_local(coord)
	
	#var r = randf()
	#if r < spawner_enemy_chance:
		#_spawn_spawner_enemy()
	#elif r < spawner_enemy_chance + throw_enemy_chance:
		#_spawn_throw_enemy()
	#else:
	_spawn_normal_enemy(data.get_random_enemy(), pos)

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

func _spawn_normal_enemy(word = data.get_random_enemy(), pos: Vector2 = _random_position()):
	var enemy = enemy_scene.instantiate()
	enemy.set_word(word)
	_add_enemy_to_scene(enemy, pos)

func _spawn_projectile(pos: Vector2, res: EnemyResource):
	var node = enemy_scene.instantiate() as TypedEnemy
	node.enemy_res = res
	node.set_word(data.get_random_projectile())
	node.z_index = 50
	_add_enemy_to_scene(node, pos)

func _add_enemy_to_scene(enemy: TypedEnemy, pos = _random_position()):
	enemy.global_position = pos
	enemy.finished.connect(func(): enemy_finished.emit(enemy))
	enemy.dropped.connect(func(node):
		node.finished.connect(func(): drop_finished.emit())
		tile_map.add_child(node)
	)
	enemy.removed.connect(func():
		#var enemies = get_tree().get_nodes_in_group(TypedEnemy.ENEMY_GROUP)
		#enemies.erase(enemy)
		enemy_removed.emit(enemy)
	)
	tile_map.add_child(enemy)

func _random_position():
	return global_position
