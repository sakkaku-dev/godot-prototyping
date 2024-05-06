extends Node3D

@onready var grid_map = $GridMap

var money := 0

func _ready():
	grid_map.dropped_off_package.connect(func():
		money += 1
		print("Money %s" % money)
	)
