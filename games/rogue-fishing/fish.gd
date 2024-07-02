class_name Fish
extends CharacterBody2D

@export var speed := 40
@export var body: Node2D

@export_category("Wander")
@export var min_wander_distance := 100
@export var idle_timer: Timer

var move_area: Rect2
var target: Vector2
var hook: Hook
var fish: FishResource

func _ready():
	idle_timer.timeout.connect(func(): target = _get_valid_wander_target())

func _physics_process(_delta):
	if hook and not hook.is_queued_for_deletion():
		global_position = hook.global_position
		return

	if not target or global_position.distance_to(target) < 5:
		return
	
	var dir = global_position.direction_to(target)
	if body:
		body.scale.x = sign(dir.x)
	velocity = dir * speed
	move_and_slide()

func _get_valid_wander_target():
	var pos = _random_target()
	# while global_position.distance_to(pos) < min_wander_distance:
	# 	pos = _random_target()
	
	return pos

func _random_target():
	var rect = move_area
	var x = randi_range(rect.position.x, rect.position.x+rect.size.x)
	var y = randi_range(rect.position.y, rect.position.y+rect.size.y)
	return Vector2(x,y) 

	# var dir = Vector2.RIGHT.rotated(randf_range(-PI/6, PI/6)) * (-1 if randf() >= 0.5 else 1)
	# return global_position + dir * randf_range(min_wander_distance, max_wander_distance)
