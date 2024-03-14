extends State

@export var speed := 300
@export var accel := 800
@onready var gravity = ProjectSettings.get("physics/2d/default_gravity_vector") * ProjectSettings.get("physics/2d/default_gravity")

func process(p: Player, delta: float):
	var motion_x = p.get_motion().x
	
	if p.is_on_floor():
		p.animation_player.play("run" if motion_x != 0 or p.velocity.length() > 0 else "idle")
	else:
		p.animation_player.play("jump")
	if motion_x:
		p.flip(motion_x < 0)

	p.velocity.x = move_toward(p.velocity.x, motion_x * speed, accel * delta)
	p.velocity += gravity
