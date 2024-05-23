class_name TimedZoneSpell
extends Area2D

@export var res: TimedZoneResource
@onready var timer = $Timer
@onready var collision_shape_2d = $CollisionShape2D

func _ready():
	if res:
		timer.timeout.connect(func(): queue_free())
		timer.start(res.duration)
		collision_shape_2d.shape = res.shape
