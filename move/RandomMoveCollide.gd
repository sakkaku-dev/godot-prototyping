class_name RandomMoveCollide
extends Node

@export var speed := 50
@export var sprite: Node2D

@onready var body: CharacterBody2D = get_parent()

var dir = Vector2.ZERO

func _ready():
	random_direction()

func random_direction():
	dir = Vector2.RIGHT.rotated(TAU * randf())

func stop():
	dir = Vector2.ZERO

func _physics_process(delta: float):
	if do_move(dir):
		var collision = body.get_last_slide_collision()
		if collision:
			var normal = collision.get_normal()
			dir = dir.bounce(normal)

			# prevent too straight bounces
			if normal.dot(dir) >= 0.95:
				var diff_sign = -1 if normal.angle() > dir.angle() else 1
				dir = dir.rotated(diff_sign * PI/4) # TODO: range?

func do_move(d):
	body.velocity = d * speed
	if d:
		sprite.scale.x = sign(d.x)
	
	return body.move_and_slide()
