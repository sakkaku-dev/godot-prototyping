extends Area3D

signal pickup(item)

func _ready() -> void:
	area_entered.connect(func(a):
		pickup.emit(a)
	)
