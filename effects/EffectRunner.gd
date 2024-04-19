class_name EffectRunner
extends Node

@export var effects: Array[Effect] = []
@export var close_effects: Array[Effect] = []

var is_running := false
var finish_count := 0
var effect_count := 0

func open():
	_run(effects, func(e):  e.open())

func close():
	_run(effects, func(e):  e.close())
	_run(close_effects, func(e):  e.close())

func _run(eff = effects, c: Callable = func(x):):
	is_running = true
	effect_count = eff.size()
	
	for e in eff:
		c.call(e)
		e.finished.connect(func():
			finish_count += 1
			if finish_count >= effect_count:
				is_running = false
		)
