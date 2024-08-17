extends CharacterBody2D

@export var bullet_scene: PackedScene

@onready var top_down_move_2d: TopDownMove2D = $TopDownMove2D
@onready var fire_rate_timer: FireRateTimer = $FireRateTimer
@onready var boomerang_catch: Hurtbox = $BoomerangCatch
@onready var aim: Node2D = $Aim

var has_bullet := true

func _ready() -> void:
	boomerang_catch.hit.connect(func(): has_bullet = true)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		if has_bullet:
			var node = bullet_scene.instantiate()
			get_tree().current_scene.add_child(node)
			node.global_position = fire_rate_timer.hitbox.global_position
			node.dir = Vector2.RIGHT.rotated(aim.global_rotation)
			has_bullet = false
		else:
			fire_rate_timer.fire()

func _physics_process(delta: float) -> void:
	top_down_move_2d.process(delta)
