class_name ChickenManager
extends Node

signal chicken_changed(total)

const GROUP = "ChickenManager"

@export var egg_catch_game: EggCatchGame
@export var max_chickens := 10
@export var total_eggs_label: Label

var worker_chickens := []
var chickens := []
var total_eggs := 10:
	set(x):
		total_eggs = x
		total_eggs_label.text = "%s" % total_eggs

func _ready():
	add_to_group(GROUP)
	egg_catch_game.total_eggs_collected.connect(func(eggs): self.total_eggs += eggs)

func is_max_chickens():
	return chickens.size() >= max_chickens

func add_chicken(chicken):
	chickens.append(chicken)
	chicken.died.connect(func(): chickens.erase(chicken))
	chicken_changed.emit(chickens.size())
