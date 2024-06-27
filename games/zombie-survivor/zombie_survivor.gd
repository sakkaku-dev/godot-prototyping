extends Node2D

@onready var player = $Player
@onready var spawner_2d = $Spawner2D
@onready var spawn_timer = $SpawnTimer

func _ready():
	InputMapper.override_key_inputs({
		"place": KEY_E,
		"item_wall": KEY_1,
	})
	
	spawn_timer.timeout.connect(func():
		var x = spawner_2d.spawn()
		x.target = player
	)
