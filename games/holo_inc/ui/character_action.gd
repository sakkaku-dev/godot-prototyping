extends BaseButton

@export var character: String
@export var action := HoloIncData.Action.COLLECTING_COINS
@export var max_value := 0

func _ready() -> void:
	HoloIncData.character_action_changed.connect(func(x):
		if x == character:
			button_pressed = _is_doing_action()
		
		if max_value > 0:
			var count = HoloIncData.count_characters_doing(action)
			disabled = count >= max_value and not button_pressed
	)
	toggled.connect(func(on):
		if on:
			HoloIncData.set_character_action(character, action)
		elif _is_doing_action():
			HoloIncData.set_character_action(character, -1)
	)

func _is_doing_action() -> bool:
	return HoloIncData.character_actions[character] == action
