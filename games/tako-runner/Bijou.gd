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

@export var speed := 380
@export var recover_speed := 30
@export var obstacles: Array[PackedScene] = []
@export var attack_area: Area2D
@export var attack_timer: Timer
@export var attack_offset := 300

@export_category("Stone Plate")
@export var stone_plate: PackedScene
@export var spawn_time_diff := 0.5
@export var spawn_distance_diff := 600

@export_category("Stone Throw")
@export var stone_throw: PackedScene
@export var stone_throw_count := 3
@export var throw_spawn_time_diff := 0.7
@export var stone_throw_timer: Timer

@export_category("Stone Fall")
@export var stone_fall: PackedScene
@export var stone_fall_spawn_time_diff := 0.5
@export var stone_fall_spawn_offset := 500

@onready var original_pos_y = position.y
@onready var fall_recover_time = $FallRecoverTime
@onready var hurtbox = $Hurtbox
@onready var gravity = ProjectSettings.get("physics/2d/default_gravity_vector") * ProjectSettings.get("physics/2d/default_gravity")
@onready var collision_shape_2d = $CollisionShape2D
@onready var attack_pos = $AttackPos

var attacks := []
var state = State.MOVING:
	set(v):
		state = v
		velocity = Vector2.ZERO
		
		var is_moving = state == State.MOVING
		hurtbox.set_deferred("monitorable", is_moving)
		collision_shape_2d.set_deferred("disabled", is_moving)
		
		if is_moving:
			_finish_attack()
			_start_move()
		
var is_attacking := false
var tw: Tween

func _ready():
	attack_area.body_entered.connect(func(_b): _attack())
	attack_timer.timeout.connect(func(): _attack())
	hurtbox.hit.connect(func():
		if tw and tw.is_running():
			tw.kill()
		
		_remove_throw_stones()
		stone_throw_timer.stop()
		self.state = State.FALLING
	)
	fall_recover_time.timeout.connect(func():
		self.state = State.RECOVERING
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
				self.state = State.MOVING
		State.MOVING: velocity = Vector2.RIGHT * speed
	
	if move_and_slide():
		if state == State.FALLING and fall_recover_time.is_stopped():
			fall_recover_time.start()

func _get_attack_target():
	var players = attack_area.get_overlapping_bodies()
	if players.is_empty():
		return attack_pos
	return players[0]

func _is_player_close():
	return attack_area.has_overlapping_bodies()

func _attack():
	if state != State.MOVING: return
	
	if _is_player_close():
		if _throw_stone():
			return 
			
		_spawn_stone_throw()
	
	
	if attacks.is_empty():
		var atk = [Attack.STONE_PLATES, Attack.STONE_FALL].pick_random()
		attacks.append(atk)
	
	var current_attack = attacks.pop_front()
	print("Attack %s from %s" % [Attack.keys()[current_attack], attacks])
	
	var target = _get_attack_target()
	match current_attack:
		Attack.STONE_PLATES: _spawn_stone_plates(target)
		Attack.STONE_FALL: _spawn_stone_fall(target)
		Attack.STONE_THROW: _spawn_stone_throw()
	
func _spawn_stone_plates(target: Node2D):
	var pos = Vector2(target.global_position.x, 0) + Vector2.RIGHT * spawn_distance_diff
	spawn(pos, stone_plate)
	_finish_attack()

func _spawn_stone_fall(target: Node2D):
	var pos = Vector2(target.global_position.x, 0) + Vector2.RIGHT * stone_fall_spawn_offset
	spawn(pos, stone_fall)
	
	_finish_attack()

func _spawn_stone_throw():
	for i in stone_throw_count:
		var node = stone_throw.instantiate()
		node.center_node = self
		get_tree().current_scene.call_deferred("add_child", node)
		await get_tree().create_timer(throw_spawn_time_diff).timeout

func _get_throwing_stones():
	return get_tree().get_nodes_in_group(StoneThrow.GROUP).filter(func(x): return not x.has_hit)

func _throw_stone():
	var stones = _get_throwing_stones()
	if stones.size() > 0:
		stones[0].attack()
		_finish_attack()
		return true
	
	return false

func _remove_throw_stones():
	for stone in get_tree().get_nodes_in_group(StoneThrow.GROUP):
		stone.queue_free()

func _finish_attack():
	attack_timer.start()

func spawn(pos: Vector2, scene: PackedScene):
	var node = scene.instantiate()
	node.global_position = pos
	get_tree().current_scene.call_deferred("add_child", node)
