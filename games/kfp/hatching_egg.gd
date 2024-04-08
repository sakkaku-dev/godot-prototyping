extends Node2D

signal hatched()

@export var timer: Timer

func _ready():
	timer.timeout.connect(func(): hatched.emit())
