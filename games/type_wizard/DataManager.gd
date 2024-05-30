class_name DataManager
extends Node

const GROUP = "DataManager"

const ENEMIES = [
	"aboleth",
	"basilisk",
	"chimera",
	"dragon",
	"efreet",
	"faerie",
	"gargoyle",
	"harpy",
	"incubus",
	"jackal",
	"kobold",
	"lich",
	"mimic",
	"naga",
	"ogre",
	"phantom",
	"quasit",
	"rakshasa",
	"sphinx",
	"troll",
	"umbra",
	"vampire",
	"werewolf",
	"xorn",
	"yeti",
	"zombie",
]

const OTHER_ENEMIES = [
	"archdemon",
	"behemoth",
	"cyclops",
	"daemon",
	"elemental",
	"fomorian",
	"gorgon",
	"hag",
	"imp",
	"jinn",
	"kraken",
	"lamia",
	"minotaur",
	"nightmare",
	"orc",
	"pixie",
	"quaggoth",
	"reaper",
	"salamander",
	"typhon",
	"undead",
	"vileblood",
	"wraith",
	"xenobi",
	"yokai",
	"zeus"
]

const SPAWN_ENEMIES = [
	"necromancer",
	"broodmother",
	"swarmhost",
	"hivequeen",
	"summoner",
	"plaguebearer",
	"warlock",
	"shaman",
	"enchanter"
]

const THROW_ENEMIES = [
	"mountain giant",
	"fire elemental",
	"storm colossus",
	"rock titan",
	"ice behemoth",
	"inferno drake",
	"forest guardian",
	"swamp leviathan",
	"thunder wyvern",
	"volcanic hydra"
]

const SCROLLS = [
	"Vilmor",
	"Tandril",
	"Xevoth",
	"Krindel",
	"Frothgar",
	"Lazik",
	"Myrzol",
	"Caldreth",
	"Wynthor",
	"Zebril"
]

const SPELL_FOLDER = "res://games/type_wizard/spells/"

@export var start_upgrades: Array[UpgradeResource] = []

var do_other_enemies := false
var enemies := []
var projectiles := []

var upgrades = []
var spells = {}

func _ready():
	add_to_group(GROUP)
	var available_spell_names = SCROLLS.duplicate()
	for file in DirAccess.get_files_at(SPELL_FOLDER):
		if not file.ends_with(".tres"): continue
		
		var spell = load(SPELL_FOLDER + file)
		var scroll = available_spell_names.pick_random()
		available_spell_names.erase(scroll)
		spells[scroll] = spell

	upgrades.append_array(start_upgrades)

func get_random_projectile():
	if projectiles.is_empty():
		projectiles = "abcdefghijklmnopqrstuvwz".split("")

	var letter = projectiles.pick_random()
	projectiles.erase(letter)
	return letter

func get_random_enemy():
	if enemies.is_empty():
		enemies = OTHER_ENEMIES.duplicate() if do_other_enemies else ENEMIES.duplicate()
		do_other_enemies = not do_other_enemies
	
	var word = enemies.pick_random()
	enemies.erase(word)
	return word

func get_random_spawner_enemy():
	return SPAWN_ENEMIES.pick_random()

func get_random_throw_enemy():
	return THROW_ENEMIES.pick_random()

func get_random_spell():
	return spells.keys().pick_random()

func get_random_upgrades(count = 3) -> Array[UpgradeResource]:
	var result: Array[UpgradeResource] = []
	var current_upgrade = upgrades.duplicate()
	if not current_upgrade.is_empty():
		for i in range(count):
			if current_upgrade.is_empty(): break
			var up = current_upgrade.pick_random()
			current_upgrade.erase(up)
			result.append(up)
	
	return result

func used_upgrade(res: UpgradeResource):
	if not res.unlock_upgrades.is_empty():
		var unlock = res.unlock_upgrades.pick_random()
		res.unlock_upgrades.erase(unlock)
		upgrades.append(unlock)
	
	res.limit -= 1
	if res.limit <= 0:
		upgrades.erase(res)
		print("Reached limit of upgrade %s" % res.title)

func get_spell(scroll_name: String) -> SpellResource:
	if scroll_name in spells:
		return spells[scroll_name]
	return null
