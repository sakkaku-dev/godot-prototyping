class_name Egg
extends Area2D

const GROUP = "EGG"

@export var speed := 50
@export var egg := true

func _ready():
	add_to_group(GROUP)

func get_size():
	return ($CollisionShape2D.shape as RectangleShape2D).size

func _physics_process(delta):
	translate(Vector2.DOWN * speed * delta)
