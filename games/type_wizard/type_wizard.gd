extends Node2D

const WORDS = [
	"castle",
	"wizard",
	"dragon",
	"sorcery",
	"knight",
	"enchanted",
	"dungeon",
	"goblin",
	"alchemy",
	"tome"
]

@export var enemies: Array[PackedScene] = []
@export var enemy_spawn_distance_from_player := 300
@export var enemy_spawn_timer: RandomTimer

var words := []
var current_word

func _ready():
	enemy_spawn_timer.timeout.connect(func(): _spawn())
	
func _spawn():
	var enemy = enemies.pick_random().instantiate()
	enemy.word = WORDS.pick_random().to_lower()
	enemy.global_position = (Vector2.RIGHT * enemy_spawn_distance_from_player).rotated(randf_range(0, TAU))
	enemy.entered.connect(func(): words.append(enemy))
	enemy.finished.connect(func():
		words.erase(enemy)
		current_word = null
	)
	add_child(enemy)

func _unhandled_input(event):
	if event is InputEventKey and event.is_pressed() and not words.is_empty():
		var key = event as InputEventKey
		
		# we don't care about modifiers
		key.shift_pressed = false
		key.ctrl_pressed = false
		key.alt_pressed = false
		key.meta_pressed = false

		var text = key.as_text()
		if text.length() != 1:
			return
		
		if not current_word:
			current_word = _find_first_words_with(text)
			print("Searching word starting with %s: %s" % [text, current_word])
			if not current_word:
				return
		
		current_word.handle_key(text)

func _find_first_words_with(key: String):
	for enemy in words:
		if enemy.word.to_lower().begins_with(key.to_lower()):
			return enemy
	return null
