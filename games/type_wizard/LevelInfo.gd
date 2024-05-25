extends HBoxContainer

@export var level: LevelManager
@export var level_label: Label
@export var exp_bar: ProgressBar

func _ready():
	level.experience_change.connect(func(exp): _update_exp(exp))
	level.level_up.connect(func(lvl): _update_level(lvl))

	_update_exp(0)
	_update_level(level.lvl)

func _update_level(lvl: int):
	level_label.text = "LV %s" % lvl

func _update_exp(exp: float):
	exp_bar.value = exp
