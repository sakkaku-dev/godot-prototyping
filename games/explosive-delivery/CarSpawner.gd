extends Node2D

@export var scene: PackedScene
@export var timer: RandomTimer

func _ready():
	timer.timeout.connect(func(): )
	

