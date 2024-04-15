class_name ChickenManager
extends Node

signal chicken_changed(total)

@export var max_chickens := 10

var chickens := []

func is_max_chickens():
	return chickens.size() >= max_chickens

func add_chicken(chicken):
	chickens.append(chicken)
	chicken.died.connect(func(): chickens.erase(chicken))
	chicken_changed.emit(chickens.size())
