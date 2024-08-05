class_name Selectable
extends Control

signal clicked()

@export var sprite: Sprite2D
@export var enabled := true

func _ready():
	sprite.material = sprite.material.duplicate()
	mouse_entered.connect(func():
		if enabled:
			set_sprite_outline(true)
	)
	mouse_exited.connect(func(): set_sprite_outline(false))
	gui_input.connect(func(ev: InputEvent):
		if ev.is_action_pressed("action") and enabled:
			clicked.emit()
	)
	set_sprite_outline(false)
	
func set_sprite_outline(enabled = false):
	var mat = sprite.material as ShaderMaterial
	mat.set_shader_parameter("thickness", 1 if enabled else 0)
	z_index = 5 if enabled else 0
