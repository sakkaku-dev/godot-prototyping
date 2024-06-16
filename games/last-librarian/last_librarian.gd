class_name LastLibrarian
extends Node2D

const INTRO_TEXT = [
	"In the distant future, the once mighty dominion of humanity lies on the brink of extinction, brought to the precipice by its own hubris and folly.",
	"The ravages of relentless wars, heedless exploitation of resources, and unchecked technological advancement have exacted a devastating toll on the planet and its inhabitants.",
	"Now, amidst the crumbling ruins of civilizations past, what remains of humanity teeters on the edge of oblivion, stripped of much of the knowledge that once defined its ascent.",
	"Amidst this desolation stands the Last Archiver, a solitary sentinel amid the relics of a lost age. She holds within her possession the accumulated wisdom of millennia, preserved within the hallowed halls of her ancient library.",
	"With this vast repository comes a solemn responsibility — to wield the power to restore or withhold, to guide or condemn. For she alone decides whether humanity will rise from its destruction or continue blindly towards demise."
]

enum Prophecy {
	ALIEN, # High Combat + not anarchy
	METEORITE, # High survival + science
	PANDEMIC, # High Science + Democracy
}

enum Knowledge {
	# Combat
	GUN_POWDER,
	EXPLOSIVES,
	ARMOER,
	BLACKSMITHING,
	FACTORY,
	SELF_DEFENSE,
	COMMUNICATION, # Internet, etc.
	
	STEAM_ENGINE,
	FIRST_AID,
	SOLAR_PANEL,
	BATTERY,
}

@onready var intro = $CanvasLayer/Intro
@onready var prophecy_ui = $CanvasLayer/ProphecyUI
@onready var prophecy = Prophecy.values().pick_random()

var combat_power := 0.0
var science := 0.0 # Wisdom of the people -> chance to discover things on their own
var survival := 0.0 # Basic survival skills -> below zero, gameover?
var government := 0.0 # Anarchy, Democracy, Tyranny | [-1, 1]

func _ready():
	#intro.show_text(INTRO_TEXT)
	intro.finished.connect(func(): )
