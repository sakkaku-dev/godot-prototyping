extends Node

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

var do_other_enemies := true
var enemies := []

var spells = {}

func _ready():
	enemies = ENEMIES.duplicate()
	
	var available_spell_names = SCROLLS.duplicate()
	for file in DirAccess.get_files_at(SPELL_FOLDER):
		var spell = load(SPELL_FOLDER + file)
		var scroll = available_spell_names.pick_random()
		available_spell_names.erase(scroll)
		spells[scroll] = spell

func get_random_enemy():
	if enemies.is_empty():
		enemies = OTHER_ENEMIES.duplicate() if do_other_enemies else ENEMIES.duplicate()
		do_other_enemies = not do_other_enemies
	
	var word = enemies.pick_random()
	enemies.erase(word)
	return word

func get_random_spell():
	return spells.keys().pick_random()

func get_spell(scroll_name: String):
	if scroll_name in spells:
		return spells[scroll_name]
	return null
