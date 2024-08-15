extends Node2D

@export var character_list: Control
@export var holo_container: Control
#@export var holo_button: BaseButton
#
#func _ready() -> void:
	#holo_button.pressed.connect(func(): HoloIncData.holo_coins += 1)

func _process(delta: float) -> void:
	HoloIncData.holo_coins += delta * HoloIncData.count_characters_doing(HoloIncData.Action.COLLECTING_COINS)
