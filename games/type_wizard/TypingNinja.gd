class_name TypingNinja
extends CharacterBody2D

const GROUP = "TypingNinja"

@onready var level_manager = $LevelManager
@onready var type_timer = $TypeTimer
@onready var enemy_spawner = $EnemySpawner
@onready var hurtbox = $Hurtbox

var typed := ""

func _ready():
	add_to_group(GROUP)
	type_timer.timeout.connect(_show)

func killed(enemy: TypedEnemy):
	level_manager.receive_exp(enemy)
	global_position = enemy.global_position

func _enemy_finished(enemy: TypedEnemy):
	killed(enemy)
	enemy.removed.emit()
	reset()

func typing(key: String):
	var word = typed + key
	var enemies = _get_enemies_for_typed(word)
	if enemies.is_empty():
		reset()
		word = key
		enemies = _get_enemies_for_typed(word)
	
	for enemy in enemies:
		if enemy.get_word() == word:
			_enemy_finished(enemy)
			return
	
	typed = word
	if not enemies.is_empty():
		_hide()

func _show():
	show()
	hurtbox.monitorable = true

func _hide():
	hide()
	hurtbox.monitorable = false
	type_timer.start()

func reset():
	typed = ""
	_show()

func _get_enemies_for_typed(s: String) -> Array:
	return enemy_spawner.get_available_enemies().filter(func(e): return e.get_word().begins_with(s))

