extends Node2D

signal collected_eggs(eggs)

@export var stone_percentage := 0.4
@export var timer: Timer

@export var count_label: Label
@export var countdown: Timer

@export var stone_scene: PackedScene
@export var egg_scene: PackedScene
@export var height := -120
@export var min_x := -140
@export var max_x := 140

@onready var kiara := $KiaraEggCatch

var eggs := 0

func _ready():
	count_label.text = "%s Eggs" % eggs
	kiara.eggs_collected.connect(func(e):
		eggs = e
		count_label.text = "%s Eggs" % eggs
	)
	
	countdown.timeout.connect(func():
		timer.stop()
		get_tree().create_timer(1.0).timeout.connect(func():
			collected_eggs.emit(eggs)
		)
		process_mode = Node.PROCESS_MODE_DISABLED
	)
	
	timer.timeout.connect(func():
		if randf() <= stone_percentage:
			_spawn(stone_scene)
		else:
			_spawn(egg_scene)
	)

	_spawn(egg_scene)

func _spawn(scene: PackedScene):
	var node = scene.instantiate()
	add_child(node)
	node.global_position = Vector2(randf_range(min_x, max_x), height)
