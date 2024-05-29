class_name Bullet
extends CharacterBody2D

@export var speed := 80
@export var target_offset := 5
@export var area_attack_scene: PackedScene
@export var height := 50

@onready var arrow = $Body/Arrow
@onready var body = $Body
@onready var lightning_line = $LightningLine

var effects := []

var on_hit_effects := []
var node_effects := []

var has_hit = false
var start_dist := 0.0
var target: TypedCharacter:
	set(v):
		target = v
		if target:
			start_dist = global_position.distance_to(target.global_position)
			target.removed.connect(func():
				if lightning_line.points.size() > 0:
					queue_free()
			)

func _ready():
	lightning_line.points = []
	lightning_line.visible = false
	
	for eff in effects:
		if eff is AirPushBackResource:
			on_hit_effects.append(eff)
		elif eff is FrostSlowResource:
			on_hit_effects.append(eff)
		elif eff is LightningEffectResource:
			on_hit_effects.append(eff)
			
			lightning_line.points = [Vector2.ZERO, to_local(target.global_position)]
			lightning_line.visible = true
			body.hide()
			_final_hit(0.2)

func _physics_process(delta):
	if not target or is_queued_for_deletion(): return
	
	var dir = global_position.direction_to(target.global_position)
	global_rotation = Vector2.RIGHT.angle_to(dir)
	velocity = dir * speed
	move_and_slide()

	var dist = global_position.distance_to(target.global_position)
	if dist < speed / 2:
		_to_final_target(dir)
		_final_hit()

func _final_hit(wait := 0.0):
	target.hit_health()
	target.apply(global_position, on_hit_effects)
	target = null
	
	await get_tree().create_timer(wait).timeout
	queue_free()

func _to_final_target(dir):
	global_position = target.global_position - dir * target_offset
