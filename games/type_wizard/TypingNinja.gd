class_name TypingNinja
extends CharacterBody2D

const GROUP = "TypingNinja"

@export var enemy_spawner: EnemySpawner
@export var knockback_force := 20

@onready var level_manager = $LevelManager
@onready var type_timer = $TypeTimer
@onready var hurtbox = $Hurtbox
@onready var push_back = $PushBack
@onready var invincible_timer = $InvincibleTimer

var typed := ""

func _ready():
	add_to_group(GROUP)
	type_timer.timeout.connect(reset)
	invincible_timer.timeout.connect(func(): hurtbox.monitorable = true)

func killed(enemy: TypedEnemy):
	level_manager.receive_exp(enemy)
	global_position = enemy.global_position
	
	for body in push_back.get_overlapping_bodies():
		body.apply_knockback(global_position, knockback_force)
	
	reset()

func _enemy_finished(enemy: TypedEnemy):
	killed(enemy)
	enemy.removed.emit()

func typing(key: String):
	var word = typed + key
	var enemies = _get_typed_enemies(word)
	var words = []
	if enemies.is_empty():
		words = _get_typed_words(word)
		if words.is_empty():
			reset()
			word = key
	else:
		for enemy in enemies:
			if enemy.get_word() == word:
				_enemy_finished(enemy)
				return
		
		if not enemies.is_empty():
			_hide()
	
	typed = word

func _hide():
	hide()
	hurtbox.monitorable = false
	invincible_timer.stop()
	type_timer.start()

func reset():
	typed = ""
	_show()

func _show():
	show()
	invincible_timer.start()

func _get_typed_enemies(s: String) -> Array:
	return enemy_spawner.get_available_enemies().filter(func(e): return e.get_word().begins_with(s))

func _get_typed_words(s: String) -> Array:
	return get_tree().get_nodes_in_group(TypedWord.GROUP).filter(func(e): return not e.is_finished() and e.get_word().begins_with(s))
