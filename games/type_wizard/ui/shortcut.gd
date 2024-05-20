extends Control

@export var key_res: ShortcutResource
@export var texture: Texture2D
@export var active_texture: Texture2D

@export_category("Nodes")
@export var image_rect: TextureRect
@export var key_image_rect: TextureRect
@export var button_rect: TextureRect

func _ready():
	image_rect.texture = key_res.image
	key_image_rect.texture = key_res.key_image

func _unhandled_input(event: InputEvent):
	if not event is InputEventKey: return
	
	var key = event as InputEventKey
	if key.keycode == key_res.event.keycode:
		button_rect.texture = active_texture if key.pressed else texture
