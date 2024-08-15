extends BaseButton

signal character_selected()

@export var character: String
@export var label: Label
@export var team_button: Control
@export var lvl_label: Label

@export var action_container: Control

func _ready() -> void:
	for a in action_container.get_children():
		a.character = character
	
	HoloIncData.character_added.connect(func(x): if x == character: _update())
	#pressed.connect(func(): character_selected.emit())
	_update()
	
	HoloIncData.item_bought.connect(func(i): if i == HoloIncData.Item.MAP: _update_actions())
	HoloIncData.fighting_changed.connect(func(): _update_experience())
	_update_actions()


func _update_actions():
	team_button.visible = HoloIncData.get_count(HoloIncData.Item.MAP) > 0

func _update():
	var count = HoloIncData.get_character_count(character)
	label.text = "%s - %sx" % [character, count]
	disabled = count <= 0
	action_container.visible = not disabled
	modulate = Color.DIM_GRAY if count <= 0 else Color.WHITE
	_update_experience()

func _update_experience():
	lvl_label.text = "Lvl %s" % HoloIncData.get_character_level(character)
