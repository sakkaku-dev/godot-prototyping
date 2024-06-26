extends CharacterBody2D

@export var speed := 280
@export var obstacles: Array[PackedScene] = []
@export var attack_area: Area2D
@export var attack_timer: Timer
@export var attack_offset := 300

func _ready():
	attack_timer.timeout.connect(func():
		var players = attack_area.get_overlapping_bodies()
		if players.is_empty(): return

		var player = players[0]
		spawn(Vector2(player.global_position.x, 0) + Vector2.RIGHT * attack_offset)
	)

func _physics_process(delta: float):
	velocity = Vector2.RIGHT * speed
	move_and_slide()

func spawn(pos: Vector2):
	var obstacle = obstacles.pick_random()
	var node = obstacle.instantiate()
	node.global_position = pos
	get_tree().current_scene.add_child(node)
