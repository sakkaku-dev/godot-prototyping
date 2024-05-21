class_name Bullet
extends CharacterBody2D

@export var max_speed_multiplier := 10
@export var speed := 70
@export var target_offset := 5
@export var area_attack_scene: PackedScene

@onready var sprite_2d = $Sprite2D

var speed_multiplier := 1.0:
	set(v):
		speed_multiplier = min(v, max_speed_multiplier)

var effects := []

var on_hit_effects := []
var node_effects := []

var target: TypedCharacter:
	set(v):
		target = v
		if target:
			target.removed.connect(func(): queue_free())

func _ready():
	for eff in effects:
		if eff is AirPushBackResource:
			#var node = area_attack_scene.instantiate()
			#node.res = eff
			#add_child(node)
			#node_effects.append(node)
			on_hit_effects.append(eff)
		elif eff is FrostSlowResource:
			on_hit_effects.append(eff)
		elif eff is LightningEffectResource:
			speed_multiplier = max_speed_multiplier + 10
			sprite_2d.hide()

func _physics_process(delta):
	if not target: return
	
	var dir = global_position.direction_to(target.global_position)
	if speed_multiplier > max_speed_multiplier:
		_to_final_target(dir)
	else:
		global_rotation = Vector2.RIGHT.angle_to(dir)
		velocity = dir * speed * speed_multiplier
		move_and_slide()
	
	var dist = global_position.distance_squared_to(target.global_position)
	if dist < 5 * speed_multiplier:
		_to_final_target(dir)
		target.hit()
		target.apply(global_position, on_hit_effects)
		for eff in node_effects:
			eff.activate()
		
		target = null
		queue_free()

func _to_final_target(dir):
	global_position = target.global_position - dir * target_offset
