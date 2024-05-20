class_name TypedEnemySpawner
extends TypedEnemy

signal spawn_enemy()

@export var offset := 5
@export var spawn_count := 1

func _on_spawn_timer_timeout():
	var pos = global_position
	var dir = global_position.direction_to(Vector2.ZERO)
	for i in range(spawn_count):
		dir = dir.rotated(randf_range(-PI/2, PI/2))
		spawn_enemy.emit(pos + dir * offset)
