extends Control

@export var button: BaseButton

func _ready() -> void:
	HoloIncData.character_action_changed.connect(func(_c): _update())
	HoloIncData.fighting_changed.connect(func(): _update())
	_update()

func _update():
	visible = HoloIncData.has_team_member()
	button.disabled = HoloIncData.is_fighting
	button.modulate = Color.DIM_GRAY if button.disabled else Color.WHITE
