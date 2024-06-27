extends Node3D

@onready var player_3d = $Player3D
@onready var spawner_3d = $Spawner3D
@onready var spawn_timer = $SpawnTimer

func _ready():
	InputMapper.override_key_inputs({
		"move_up": KEY_W,
		"move_down": KEY_S,
		"move_left": KEY_A,
		"move_right": KEY_D,

		"attack": KEY_SPACE,
		"item_wall": KEY_1,
	})
	
	spawn_timer.timeout.connect(func():
		var node = spawner_3d.spawn()
		node.target = player_3d
	)
