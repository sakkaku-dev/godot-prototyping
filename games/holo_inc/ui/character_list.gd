extends Control

@export var container: Control
@export var row_scene: PackedScene
@export var details_page: Control
@export var list: Control

func _ready() -> void:
	_show_list()
	visibility_changed.connect(func(): if not visible: _show_list())
	
	for character in HoloIncData.CHARACTERS.keys():
		var row = row_scene.instantiate()
		row.character = character
		row.character_selected.connect(func(): _on_character_selected(character))
		container.add_child(row)

func _show_list():
	details_page.hide()
	list.show()

func _show_details():
	details_page.show()
	list.hide()

func _on_character_selected(character):
	details_page.character = character
	_show_details()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and details_page.visible:
		_show_list()
		get_viewport().set_input_as_handled()
