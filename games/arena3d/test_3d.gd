extends Node3D

@onready var grass_2 = $Grass2
@onready var player = $Player

func _ready():
	InputMapper.override_key_inputs({
		"move_up": KEY_W,
		"move_down": KEY_S,
		"move_left": KEY_A,
		"move_right": KEY_D,

		"jump": KEY_SPACE,
		"run": KEY_SHIFT,
		"roll": KEY_CTRL,
	})

func _process(delta):
	var mesh = grass_2.mesh as Mesh
	var mat = mesh.surface_get_material(0) as ShaderMaterial
	mat.set_shader_parameter("character_position", player.global_position)
