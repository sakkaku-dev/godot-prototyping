extends Node2D

@export var button: BaseButton

func _ready() -> void:
	KfpManager.add_random_chicken()
	button.pressed.connect(func(): KfpManager.add_item(KfpUpgradeManager.EGG))
