class_name Fish
extends CharacterBody2D

@export var move_dir := Vector2(1, 0)
@export var body: Node2D
@export var fish: FishResource

var hook: Hook
var is_flipped := false

func _ready():
	move_dir = move_dir.rotated(global_rotation)
	is_flipped = Vector2.LEFT.dot(move_dir) > 0
	
	body.scale.y = -1 if is_flipped else 1
	body.scale.x = sign(move_dir.x) * body.scale.y

func _physics_process(_delta):
	if hook and is_instance_valid(hook):
		global_position = hook.global_position
		return
	
	velocity = move_dir
	move_and_slide()
