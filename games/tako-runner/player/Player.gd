class_name Player
extends CharacterBody2D

@export var speed := 300
@export var accel := 1200
@export var deaccel := 800
@export var jump_force := 300

@export_category("Boost")
@export var boost_speed := 1000
@export var boost_deaccel := 1500
@export var boost_jump := 500
@export var boost_air_jump := 200

@export_category("Wall Slide")
@export var gravity_multiplier := 0.2
@export var slide_terminal_velocity := 10
@export var leave_slide_threshold := 0.2
@export var wall_jump_force := 400
@export var wall_jump_angle := 70.0

@onready var gravity = ProjectSettings.get("physics/2d/default_gravity_vector") * ProjectSettings.get("physics/2d/default_gravity")
@onready var animation_player = $AnimationPlayer
@onready var sprite_2d = $CollisionShape2D/Sprite2D
@onready var right_wall_cast = $CollisionShape2D/RightWallCast
@onready var left_wall_cast = $CollisionShape2D/LeftWallCast
@onready var boost_timeout = $BoostTimeout
@onready var boost_double_tap_timeout = $BoostDoubleTapTimeout

var wall_dir := Vector2.ZERO:
	set(v):
		wall_dir = v
		if wall_dir:
			flip(get_wall_normal().x < 0)
			wall_leave_motion = 0
			
var wall_leave_motion := 0.0

var boost_available := true:
	set(v):
		boost_available = v
		if not boost_available:
			boost_timeout.start()

func _ready():
	boost_timeout.timeout.connect(func(): boost_available = true)
	animation_player.play("RESET")

func _physics_process(delta):
	if wall_dir:
		velocity += gravity * gravity_multiplier
		if velocity.y >= slide_terminal_velocity:
			velocity.y = slide_terminal_velocity
			
		if get_motion().x == wall_dir.x:
			wall_leave_motion += delta
		else:
			wall_leave_motion = 0
			
		var moved_away_from_wall = wall_leave_motion >= leave_slide_threshold
		if is_on_floor() or not get_wall_collision() or moved_away_from_wall:
			wall_dir = Vector2.ZERO
		
	var motion_x = get_motion().x
	if motion_x:
		flip(motion_x < 0)

	if motion_x == 0:
		velocity.x = move_toward(velocity.x, 0, deaccel * delta)
	elif has_boost():
		velocity.x = move_toward(velocity.x, motion_x * speed, boost_deaccel * delta)
	else:
		velocity.x = move_toward(velocity.x, motion_x * speed, accel * delta)
	
	velocity += gravity
	
	move_and_slide()
	
	if not is_on_floor() and is_moving_against_wall() and not wall_dir:
		self.wall_dir = get_wall_collision() * -1

func get_motion():
	return Input.get_vector("move_left", "move_right", "move_up", "move_down")

func _unhandled_input(ev: InputEvent):
	if ev.is_action_pressed("jump"):
		if wall_dir:
			var wall_n = get_wall_collision() * -1
			if wall_n:
				wall_n = wall_n.rotated(deg_to_rad(wall_jump_angle) * -sign(wall_n.x))
				velocity = wall_n * wall_jump_force
				return
		
		if is_on_floor():
			if Input.is_action_pressed("boost") and boost_available:
				velocity.y = -boost_jump
				self.boost_available = false
			else:
				velocity.y = -jump_force
		elif boost_available:
			var motion = get_motion()
			var dir = Vector2.UP * boost_jump
			if motion.x != 0:
				dir = dir.rotated(deg_to_rad(45 if motion.x > 0 else - 45))
			velocity.y = dir.y
			velocity.x += dir.x
			self.boost_available = false
	elif is_on_floor() and ev.is_action_pressed("boost") and boost_available:
		if not boost_double_tap_timeout.is_stopped():
			var motion = get_motion()
			if motion.x != 0:
				velocity.x = motion.x * boost_speed
				self.boost_available = false
		else:
			boost_double_tap_timeout.start()
	
	if not "attack" in animation_player.current_animation:
		if ev.is_action_pressed("attack"):
			animation_player.play("attack")

func has_boost():
	return abs(velocity.x) > speed

func flip(flipped: bool):
	sprite_2d.scale.x = -1 if flipped else 1

func get_face_dir():
	return Vector2.LEFT if sprite_2d.scale.x < 0 else Vector2.RIGHT

func get_wall_collision():
	if left_wall_cast.is_colliding():
		return Vector2.LEFT
	if right_wall_cast.is_colliding():
		return Vector2.RIGHT
	return Vector2.ZERO

func is_moving_against_wall():
	var wall_n = get_wall_collision()
	return is_on_wall() and wall_n and sign(get_motion().x) == sign(wall_n.x)
