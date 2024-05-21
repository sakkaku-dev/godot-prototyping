extends Area2D

@export var res: Resource

@onready var collision_shape_2d = $CollisionShape2D

func _ready():
	if res and res.shape:
		collision_shape_2d.shape = res.shape

func activate():
	for body in get_overlapping_bodies():
		body.apply(global_position, [res])
	
	queue_free()
