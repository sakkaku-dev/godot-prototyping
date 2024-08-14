extends BaseButton

signal character_selected()

@export var character: String
@export var label: Label

func _ready() -> void:
	HoloIncData.character_added.connect(func(x): if x == character: _update())
	pressed.connect(func(): character_selected.emit())
	_update()

func _update():
	var count = HoloIncData.get_character_count(character)
	label.text = "%s - %sx" % [character, count]
	disabled = count <= 0
