extends State

@export var swing_move_force := 5
@export var decrease_swing_dist := 50
@export var stick_delay := 0.1

@export var pull_speed := 100
@onready var gravity = ProjectSettings.get("physics/2d/default_gravity_vector") * ProjectSettings.get("physics/2d/default_gravity")

var reduce_swing_dist := 0.0
var swing_dist := 0.0
var time := 0.0

func enter(p: Player):
	reduce_swing_dist = 0.0
	swing_dist = 0.0
	time = .0
	swing_dist = p.get_contact_point().length()

func process(p: Player, delta: float):
	var point = p.get_contact_point()
	var dir = point.normalized()
	var current_dist = point.length()
	var motion = p.get_motion()
	var normal = p.get_contact_normal()
	
	p.animation_player.play("jump")
	if motion.x:
		p.flip(motion.x < 0)
	else:
		p.flip(p.velocity.x < 0)
	
	#if p.ground_cast.is_colliding():
		#var collision = p.ground_cast.get_collision_point()
		#var dist = p.global_position.distance_to(collision)
		#var relative = dist / p.ground_cast.target_position.y
		#reduce_swing_dist += 500 / max(relative, 0.01)
	#else:
		#reduce_swing_dist = 0
	
	var contact_ceiling: bool = normal.dot(Vector2.DOWN) > 0.8 #and normal.dot(dir) <= -0.8
	
	if contact_ceiling:
		# https://stackoverflow.com/questions/75195734/descending-pendulum-motion-in-physics-process
		var gravity_speed = 1500 #30000
		var air_resistance = -200
		var swing_length = swing_dist - reduce_swing_dist
		
		p.velocity.y += gravity_speed * delta
		p.velocity += (p.velocity.normalized() * air_resistance * delta).limit_length(p.velocity.length())

		#pendulum motion
		var theta=Vector2.RIGHT.angle_to(point) * -1 # angle between local x_axis & pivot point vector
		var sin_theta=sin(theta)
		var cos_theta=cos(theta)
		p.velocity.x = p.velocity.x + p.velocity.y*sin_theta*cos_theta - p.velocity.x*cos_theta*cos_theta
		p.velocity.y = p.velocity.y + p.velocity.x*sin_theta*cos_theta - p.velocity.y*sin_theta*sin_theta

		var tension = clamp(current_dist - swing_length, 0, 1) * gravity_speed
		p.velocity += dir * tension * delta
	
		if Input.is_action_pressed("secondary"):
			p.velocity += dir * pull_speed
			
		p.velocity.x += motion.x * swing_move_force
	else:
		p.velocity += dir * pull_speed
	
	if p.is_on_wall() or p.is_on_ceiling() or p.is_on_floor():
		time += delta
		if time >= stick_delay:
			p.state = Player.STICK
	else:
		time = .0
