extends Area2D

signal hit()

@export var knockback := 200
@export var rot_speed := 3.0
@export var move_speed := 700
@export var radius := 30

@onready var knockback_area = $KnockbackArea
@onready var hurtbox = $Hurtbox
@onready var gravity_v = ProjectSettings.get("physics/2d/default_gravity_vector") * ProjectSettings.get("physics/2d/default_gravity")

var center_node: Node2D
var alpha := 0.0
var throw_dir: Vector2
var has_hit := false

func _ready():
	_update_pos()
	knockback_area.hit.connect(func():
		has_hit = true
	)
	hurtbox.hit.connect(func():
		hit.emit()
		queue_free()
	)

func _physics_process(delta):
	if has_hit:
		global_position += gravity_v
		return
	
	if throw_dir:
		global_position += throw_dir * move_speed * delta
		return
	
	_update_pos()
	alpha += delta * rot_speed

func _update_pos():
	global_position = center_node.global_position + Vector2(cos(alpha), sin(alpha) * 0.5) * radius

func attack(player: CharacterBody2D):
	var target = player.global_position + (Vector2.RIGHT * 50) if player.velocity else Vector2.ZERO
	throw_dir = global_position.direction_to(target)
