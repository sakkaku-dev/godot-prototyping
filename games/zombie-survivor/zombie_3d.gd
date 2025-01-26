extends CharacterBody3D

@export var speed := 5
@export var damage := 1

@export var pivot: Node3D
@export var hit_box: Area3D
@export var hurt_box: Hurtbox3D

@onready var navigation_agent_3d = $NavigationAgent3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var target: Node3D
var attacking := false:
	set(v):
		attacking = v
		if attacking:
			animation_player.play("attack")
var knockback := Vector3.ZERO

func _ready() -> void:
	hurt_box.hit.connect(func(knock): knockback = knock)
	hurt_box.died.connect(func(): queue_free())
	
	animation_player.animation_finished.connect(func(anim):
		if anim == "attack":
			attacking = false
	)

func _physics_process(delta):
	if knockback:
		knockback = knockback.move_toward(Vector3.ZERO, delta * 10)
		velocity = knockback
		return
	
	if attacking: return
	
	if target != null:
		navigation_agent_3d.target_position = target.global_position
	else:
		navigation_agent_3d.target_position = Vector3.ZERO

	if navigation_agent_3d.is_navigation_finished():
		return

	if hit_box.has_overlapping_areas():
		attacking = true
		return

	var next_path_position = navigation_agent_3d.get_next_path_position()
	var new_velocity = global_position.direction_to(next_path_position) * speed
	_on_velocity_computed(new_velocity)
	
	pivot.basis = Basis.looking_at(new_velocity)
	
func _on_velocity_computed(safe_velocity):
	velocity = safe_velocity
	move_and_slide()

func attack():
	for body in hit_box.get_overlapping_areas():
		body.damage(damage, global_position)
