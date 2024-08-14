extends Control

@export var character: String
@export var label: Label
@export var collect_coin_button: Button

func _ready() -> void:
	visibility_changed.connect(_update)
	collect_coin_button.pressed.connect(func(): HoloIncData.set_character_action(character, HoloIncData.Action.COLLECTING_COINS))

func _update():
	if visible:
		label.text = "%s" % [character]
