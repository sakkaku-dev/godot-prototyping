class_name TypedEnemyThrow
extends TypedEnemy

signal spawn_enemy(pos, enemy)

@export var throw_enemy: EnemyResource
@export var throw_stop_time := 0.5

@onready var throw_timer: RandomTimer= $ThrowTimer

var is_throwing := false

func _on_throw_timer_timeout():
	if is_on_screen():
		is_throwing = true
		await get_tree().create_timer(throw_stop_time).timeout
		spawn_enemy.emit(global_position, throw_enemy)
		await get_tree().create_timer(throw_stop_time).timeout
		is_throwing = false
	
	throw_timer.random_start()

func _physics_process(delta):
	if not is_throwing or knockback.length() > 0:
		super._physics_process(delta)
