class_name TypedEnemySpawner
extends TypedEnemy

signal spawn_enemy(pos, enemy)

@export var spawn_enemy_res: EnemyResource

@export var offset := 5
@export var spawn_count := 1

func _on_spawn_timer_timeout():
	if not is_on_screen(): return
	
	var pos = global_position
	var dir = global_position.direction_to(Vector2.ZERO)
	for i in range(spawn_count):
		dir = dir.rotated(randf_range(-PI/2, PI/2))
		spawn_enemy.emit(pos + dir * offset, spawn_enemy_res)
