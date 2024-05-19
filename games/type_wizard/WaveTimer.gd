class_name WaveTimer
extends Timer

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

signal spawn()
signal wave_started()
signal wave_stopped()

@export var enemy_spawn_timer: RandomTimer

func _ready():
	timeout.connect(func(): _stop_wave())
	enemy_spawn_timer.timeout.connect(func(): spawn.emit())

func start_wave():
	start()
	enemy_spawn_timer.start()
	wave_started.emit()

func _stop_wave():
	enemy_spawn_timer.stop()
	wave_stopped.emit()
