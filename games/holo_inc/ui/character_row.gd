extends BaseButton

signal character_selected()

@export var character: String
@export var label: Label

@export var action_container: Control

func _ready() -> void:
	HoloIncData.character_added.connect(func(x): if x == character: _update())
	pressed.connect(func(): character_selected.emit())
	_update()

	for a in action_container.get_children():
		a.character = character

func _update():
	var count = HoloIncData.get_character_count(character)
	label.text = "%s - %sx" % [character, count]
	disabled = count <= 0
	action_container.visible = not disabled
