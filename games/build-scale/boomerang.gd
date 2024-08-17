extends CharacterBody2D

@export var speed := 300
@export var hurtbox: Hurtbox
@export var hit_box: HitBox

@onready var inital_speed := speed

var dir := Vector2.ZERO
var target: Node2D

var hits := 0:
	set(v):
		hits = v
		var s = clamp(1 + hits * 0.1, 1, 3)
		scale = Vector2(s, s)
		
		speed = clamp(inital_speed + hits * 5, inital_speed, inital_speed + 100)
		hit_box.damage = hits + 1
		
		print("Scale %s, Speed %s" % [s, speed])

func _ready() -> void:
	hit_box.hit_target.connect(func(t):
		if target == t:
			queue_free()
	)
	hurtbox.hit_by.connect(func(target: Node2D):
		var dir = Vector2.RIGHT.rotated(target.global_rotation)
		self.target = null
		self.dir = dir
		hits += 1
	)

func _physics_process(delta: float) -> void:
	if target:
		dir = global_position.direction_to(target.global_position)
	
	velocity = dir * speed
	if move_and_slide():
		target = get_tree().get_first_node_in_group("player")
