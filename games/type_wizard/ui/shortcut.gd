class_name ShortcutKey
extends Control

signal changed(active)

@export var key_res: ShortcutResource
@export var texture: Texture2D
@export var active_texture: Texture2D
@export var toggle := false

@export_category("Nodes")
@export var image_rect: TextureRect
@export var key_image_rect: TextureRect
@export var button_rect: TextureRect

var active := false:
	set(v):
		if v == active: return
		
		active = v
		changed.emit(active)
		button_rect.texture = active_texture if active else texture

func _ready():
	image_rect.texture = key_res.image
	key_image_rect.texture = key_res.key_image
	
func _process(delta):
	if not toggle:
		self.active = Input.is_key_pressed(key_res.event.keycode)

func _unhandled_input(event: InputEvent):
	if not toggle: return
	if not event is InputEventKey: return
	
	var key = event as InputEventKey
	if key.keycode != key_res.event.keycode: return
	
	if toggle:
		if key.pressed:
			self.active = not active
	else:
		self.active = key.pressed
