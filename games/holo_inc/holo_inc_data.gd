extends Node

signal holo_coins_changed()
signal map_changed()
signal item_bought(item: Item)

signal character_added(character: String)
signal character_action_changed(character: String)

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

enum Item {
	GACHA,
	MAP,
	COIN,
}

var characters := {}
var character_actions := {}

var map := 0.0:
	set(v): map = v; map_changed.emit()
var holo_coins := 0.0:
	set(v): holo_coins = v; holo_coins_changed.emit()

var gacha_bought := 1

####################
#### Characters ####
####################

func set_character_action(character: String, action: Action):
	character_actions[character] = action
	character_action_changed.emit(character)

func get_total_characters() -> int:
	return characters.values().reduce(func(a, b): return a + b, 0)

func get_character_count(character: String) -> int:
	if not character in characters: return 0
	return characters[character]

func count_characters_doing(action: Action) -> int:
	return character_actions.keys() \
		.filter(func(k): return character_actions[k] == action) \
		.map(func(k): return get_character_count(k)) \
		.reduce(func(a, b): return a+b, 0)

####################
###### Items #######
####################

func buy(item: Item):
	var price = get_price(item)
	if holo_coins < price:
		print("Not enough coins for %s" % [Item.keys()[item]])
		return

	self.holo_coins -= price

	match item:
		Item.GACHA: _buy_gacha()
		Item.MAP: self.map += 1
		Item.COIN: self.holo_coins += 1
		
	item_bought.emit(item)
	print("Bought item %s" % [Item.keys()[item]])

func _buy_gacha():
	var character = CHARACTERS.keys().pick_random()
	if not character in characters:
		characters[character] = 0
	
	print("New Character %s" % character)
	characters[character] += 1
	character_added.emit(character)
	self.gacha_bought += 1

func get_price(item: Item):
	match item:
		Item.GACHA: return floor(log(gacha_bought) * 50 + 10)
		Item.MAP: return 100

	return 0

func get_count(item: Item):
	match item:
		Item.GACHA: return get_total_characters()
		Item.MAP: return map
		Item.COIN: return holo_coins

	return 0

func can_buy(item: Item):
	return get_price(item) <= holo_coins
