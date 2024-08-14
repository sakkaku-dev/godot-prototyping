extends Node

signal character_added(character: String)

const CHARACTERS = {
	"INA": {},
	"KIARA": {},
	"GURA": {},
	"CALLI": {},
	"AMELIA": {},
}

enum Action {
	COLLECTING_COINS,
}

var characters := {}
var character_actions := {}

func add_random_character():
	var character = CHARACTERS.keys().pick_random()
	if not character in characters:
		characters[character] = 0
	
	print("New Character %s" % character)
	characters[character] += 1
	character_added.emit(character)

func set_character_action(character: String, action: Action):
	character_actions[character] = action

func get_total_characters() -> int:
	return characters.values().reduce(func(a, b): return a + b, 0)

func get_character_count(character: String) -> int:
	if not character in characters: return 0
	return characters[character]

func count_characters_doing(action: Action) -> int:
	return character_actions.keys().filter(func(k): return character_actions[k] == action).size()
