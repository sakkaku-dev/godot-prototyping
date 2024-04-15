class_name EffectRunner
extends Node

@export var effects: Array[Effect] = []
@export var close_effects: Array[Effect] = []

func open():
	_run(effects, func(e):  e.open())

func close():
	_run(effects, func(e):  e.close())
	_run(close_effects, func(e):  e.close())

func _run(eff = effects, c: Callable = func(x):):
	for e in eff:
		c.call(e)
