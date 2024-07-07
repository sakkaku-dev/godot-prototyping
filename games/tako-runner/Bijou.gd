extends CharacterBody2D

enum Attack {
	STONE_PLATES,
	STONE_THROW,
	STONE_FALL,
}

enum State {
	FALLING,
	RECOVERING,
	MOVING,
}

@export var speed := 250
@export var recover_speed := 30
@export var obstacles: Array[PackedScene] = []
@export var attack_area: Area2D
@export var attack_timer: Timer
@export var attack_offset := 300

@export_category("Stone Plate")
@export var stone_plate: PackedScene
@export var stone_plate_count := 3
@export var spawn_time_diff := 0.5
@export var spawn_distance_diff := 100

@export_category("Stone Throw")
@export var stone_throw: PackedScene
@export var stone_throw_count := 3
@export var throw_spawn_time_diff := 0.7
@export var stone_throw_timer: Timer

@export_category("Stone Fall")
@export var stone_fall: PackedScene
@export var stone_fall_count := 2
@export var stone_fall_spawn_time_diff := 3.0
@export var stone_fall_spawn_offset := 350

@onready var original_pos_y = position.y
@onready var fall_recover_time = $FallRecoverTime
@onready var hurtbox = $Hurtbox
@onready var gravity = ProjectSettings.get("physics/2d/default_gravity_vector") * ProjectSettings.get("physics/2d/default_gravity")

var state = State.MOVING
var is_attacking := false
var player: Player
var tw: Tween

func _ready():
	attack_area.body_entered.connect(func(_b): _attack())
	attack_timer.timeout.connect(func(): _attack())
	hurtbox.hit.connect(func():
		if tw and tw.is_running():
			tw.kill()
		
		_remove_throw_stones()
		stone_throw_timer.stop()
		
		velocity = Vector2.ZERO
		state = State.FALLING
	)
	fall_recover_time.timeout.connect(func():
		velocity = Vector2.ZERO
		state = State.RECOVERING
	)
	stone_throw_timer.timeout.connect(func(): _throw_stone())
	
	_start_move()
	
func _start_move():
	tw = create_tween().set_loops().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tw.tween_property(self, "global_position:y", original_pos_y - 20, 1.0)
	tw.tween_property(self, "global_position:y", original_pos_y + 20, 1.0)

func _physics_process(delta: float):
	match state:
		State.FALLING: velocity += gravity
		State.RECOVERING:
			var dir = original_pos_y - global_position.y
			velocity.y += sign(dir) * recover_speed
			if abs(global_position.y - original_pos_y) < 5:
				state = State.MOVING
		State.MOVING: velocity = Vector2.RIGHT * speed
	
	if move_and_slide():
		if state == State.FALLING and fall_recover_time.is_stopped():
			fall_recover_time.start()
	
func _attack():
	var atk = Attack.values().pick_random()
	
	var players = attack_area.get_overlapping_bodies()
	if players.is_empty() or is_attacking:
		return
	
	print("Attack %s" % Attack.keys()[atk])
	player = players[0]
	var pos = Vector2(player.global_position.x, 0) + Vector2.RIGHT * attack_offset
	
	is_attacking = true
	match atk:
		Attack.STONE_PLATES: _spawn_stone_plates(pos)
		Attack.STONE_THROW: _spawn_stone_throw()
		Attack.STONE_FALL: _spawn_stone_fall()
	
func _spawn_stone_plates(pos: Vector2):
	for i in stone_plate_count:
		spawn(pos + Vector2.RIGHT * spawn_distance_diff * i, stone_plate)
		await get_tree().create_timer(spawn_time_diff).timeout
		if state != State.MOVING:
			break
	
	_finish_attack()

func _spawn_stone_fall():
	for i in stone_fall_count:
		spawn(Vector2(player.global_position.x, 0) + Vector2.RIGHT * stone_fall_spawn_offset, stone_fall)
		await get_tree().create_timer(stone_fall_spawn_time_diff).timeout
		if state != State.MOVING:
			break
	
	_finish_attack()

func _spawn_stone_throw():
	for i in stone_throw_count:
		var node = stone_throw.instantiate()
		node.center_node = self
		get_tree().current_scene.call_deferred("add_child", node)
		await get_tree().create_timer(throw_spawn_time_diff).timeout
		if state != State.MOVING:
			break
		
	stone_throw_timer.start()

func _throw_stone():
	var stones = get_tree().get_nodes_in_group(StoneThrow.GROUP)
	print("Stones %s" % [stones])
	if stones.size() > 0:
		stones[0].attack(player)
		stone_throw_timer.start()
	else:
		_finish_attack()

func _remove_throw_stones():
	for stone in get_tree().get_nodes_in_group(StoneThrow.GROUP):
		stone.queue_free()

func _finish_attack():
	is_attacking = false
	attack_timer.start()

func spawn(pos: Vector2, scene: PackedScene):
	var node = scene.instantiate()
	node.global_position = pos
	get_tree().current_scene.call_deferred("add_child", node)
