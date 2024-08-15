extends BaseButton

@export var character: String
@export var action := HoloIncData.Action.COLLECTING_COINS

func _ready() -> void:
	HoloIncData.character_action_changed.connect(func(x):
		if x == character:
			button_pressed = HoloIncData.character_actions[character] == action
	)
	toggled.connect(func(on):
		HoloIncData.set_character_action(character, action if on else -1)
	)
