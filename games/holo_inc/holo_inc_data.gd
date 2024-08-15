extends Node

signal holo_coins_changed()
signal map_changed()
signal item_bought(item: Item)
signal fighting_changed()
signal team_health_changed()
signal enemy_health_changed()

signal character_added(character: String)
signal character_action_changed(character: String)

const CHARACTERS = {
	"INA": {},
	"KIARA": {},
	"GURA": {},
	"CALLI": {},
	"AMELIA": {},
	
	"OKAYU": {},
	"KORONE": {},
	"FUBUKI": {},
	"MIO": {},
}

enum Action {
	COLLECTING_COINS,
	FIGHT_TEAM,
}

enum Item {
	GACHA,
	MAP,
	COIN,
}

var characters := {}
var character_actions := {}

var team_health := -1.0:
	set(v):
		team_health = max(v, 0)
		team_health_changed.emit()

		if team_health <= 0:
			if is_fighting:
				print("Team lost")
			
			is_fighting = false

var enemy_health := -1.0:
	set(v):
		enemy_health = v
		enemy_health_changed.emit()

		if enemy_health <= 0:
			if is_fighting:
				self.map += 1
				print("Enemies defeated")

			is_fighting = false

var is_fighting := false:
	set(v): is_fighting = v; fighting_changed.emit()

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
	
	print(character_actions)

func get_total_characters() -> int:
	return characters.values().reduce(func(a, b): return a + b, 0)

func get_character_count(character: String) -> int:
	if not character in characters: return 0
	return characters[character]

func count_characters_doing(action: Action, include_char_count := false) -> int:
	return character_actions.keys() \
		.filter(func(k): return character_actions[k] == action) \
		.map(func(k): return get_character_count(k) if include_char_count else 1) \
		.reduce(func(a, b): return a+b, 0)
	
####################
###### Fight #######
####################

func start_fight():
	team_health = get_team_health()
	#if team_health < 0:
		#team_health = get_team_health()
	#elif team_health == 0:
		#print("Team has no health to fight")
		#return
	
	enemy_health = get_enemy_health(map)
	is_fighting = true

func has_team_member() -> bool:
	return count_characters_doing(Action.FIGHT_TEAM) >= 1

func get_team_health() -> float:
	return count_characters_doing(Action.FIGHT_TEAM, true)

func get_enemy_health(lvl: float) -> float:
	return pow(2, lvl)

func get_enemy_strength(lvl: float) -> float:
	return pow(1.2, lvl)

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
		Item.MAP: return pow(5, map) + 100

	return 0

func get_count(item: Item):
	match item:
		Item.GACHA: return get_total_characters()
		Item.MAP: return map
		Item.COIN: return holo_coins

	return 0

func can_buy(item: Item):
	if item == Item.MAP:
		return get_price(item) <= holo_coins and int(floor(get_count(item))) % 10 == 0
	return get_price(item) <= holo_coins
