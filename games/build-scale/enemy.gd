extends CharacterBody2D

@onready var navigation_move_2d: NavigationMove2D = $NavigationMove2D
@onready var hurtbox: Hurtbox = $Hurtbox

@export var knockback := 150

var current_knockback := Vector2.ZERO

func _ready() -> void:
	hurtbox.hit_by.connect(func(target: Node2D):
		current_knockback = target.global_position.direction_to(global_position) * knockback
	)
	hurtbox.died.connect(func(): queue_free())

func _physics_process(delta: float) -> void:
	if current_knockback:
		velocity = current_knockback
		current_knockback = current_knockback.move_toward(Vector2.ZERO, delta * 300)
		move_and_slide()
		return
	
	navigation_move_2d.set_target(get_tree().get_first_node_in_group("player").global_position)
	navigation_move_2d.process(delta)
