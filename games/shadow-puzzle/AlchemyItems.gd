extends Control

@export var character: ShadowAlchemist
@export var open_button: TextureButton
@export var container: GridContainer

func _ready():
	close()
	open_button.pressed.connect(func(): toggle())

func _unhandled_input(event):
	if event.is_action_pressed("inventory"):
		get_viewport().set_input_as_handled()
		toggle()

func toggle():
	if visible:
		close()
	else:
		open()

func open():
	for c in container.get_children():
		c.queue_free()
	
	for item in character.items:
		var btn = TextureButton.new()
		btn.ignore_texture_size = true
		btn.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
		btn.custom_minimum_size = Vector2(30, 30)
		btn.texture_normal = load("res://icon.svg")
		btn.pressed.connect(func():
			character.item_hold(ShadowAlchemyItem.Type.NITROGEN)
			close()
		)
		container.add_child(btn)
	
	show()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func close():
	hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
