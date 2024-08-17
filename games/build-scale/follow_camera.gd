extends Camera3D

@export var hp_label: Label
@export var coin_label: Label

@export var max_health := 3
@onready var health := max_health:
	set(v):
		health = v
		hp_label.text = "%s" % v

var coins := 0:
	set(v):
		coins = v
		coin_label.text = "%s" % v

var follow_target: Coin

func _ready() -> void:
	follow_target = spawn_new()
	setup_target()

func spawn_new():
	var spawn = get_tree().get_first_node_in_group("coin_spawn")
	return spawn.spawn()

func setup_target():
	follow_target.deadend_reached.connect(func():
		follow_target.queue_free()
		follow_target = spawn_new()
		setup_target()
	)
	follow_target.picked_up.connect(func(item):
		match item:
			ItemResource.Type.Health:
				health += 1
				if health > max_health:
					health = max_health
			ItemResource.Type.Coin:
				coins += 1
	)

func _process(delta: float) -> void:
	if is_instance_valid(follow_target) and is_inside_tree():
		global_position.y = follow_target.global_position.y
