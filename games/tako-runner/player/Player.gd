class_name Player
extends CharacterBody2D

enum State {
	MOVE,
	DASH,
	KNOCKBACK,
	WALL_RUN,
	BACK_MOVE,
}

@export var speed := 400
@export var accel := 500
@export var deaccel := 800
@export var knockback_deaccel := 3000
@export var knockback_force := 800
@export var jump_force := 400

@export var back_move_deaccel := 2000
@export var back_move_force := 400

@export_category("Boost")
@export var boost_speed := 800
@export var boost_deaccel := 1800
@export var boost_air_jump := 400

@export_category("Wall Run")
@export var initial_wall_run_speed := 400
@export var gravity_multiplier := 0.2
@export var slide_terminal_velocity := -10

@onready var gravity = ProjectSettings.get("physics/2d/default_gravity_vector") * ProjectSettings.get("physics/2d/default_gravity")
@onready var animation_player = $AnimationPlayer
@onready var sprite_2d = $CollisionShape2D/Sprite2D
@onready var right_wall_cast = $RightWallCast
@onready var left_wall_cast = $LeftWallCast
@onready var boost_timeout = $BoostTimeout
@onready var collision_shape_2d = $CollisionShape2D
@onready var attack_count_reset = $AttackCountReset
@onready var knockout_recover_timer = $KnockoutRecoverTimer
@onready var dash_recovery = $DashRecovery

var state = State.MOVE
var has_double_jumped := false
var attack_count := 0:
	set(v):
		attack_count = v % 2

var boost_available := true:
	set(v):
		boost_available = v
		if not boost_available:
			boost_timeout.start()

func _ready():
	dash_recovery.timeout.connect(func(): state = State.MOVE)
	attack_count_reset.timeout.connect(func(): attack_count = 0)
	boost_timeout.timeout.connect(func(): boost_available = true)
	knockout_recover_timer.timeout.connect(func(): state = State.MOVE)
	animation_player.play("RESET")

func _move_recovery(deaccel: float, timer: Timer):
	if velocity.length() <= 10 and timer.is_stopped():
		timer.start()
	
	velocity.x = move_toward(velocity.x, 0, deaccel)
	velocity.y += gravity.y

func _physics_process(delta):
	match state:
		State.MOVE:
			_move(delta)
			velocity.y += gravity.y
	
			if is_moving_against_wall():
				velocity.y -= initial_wall_run_speed
				state = State.WALL_RUN
		State.KNOCKBACK:
			_move_recovery(knockback_deaccel * delta, knockout_recover_timer)
		State.BACK_MOVE:
			if velocity.length() <= 10 and not Input.is_action_pressed("move_left"):
				state = State.MOVE
			
			velocity.x = move_toward(velocity.x, 0, back_move_deaccel * delta)
			velocity.y += gravity.y
		State.DASH:
			_move_recovery(boost_deaccel * delta, dash_recovery)
		State.WALL_RUN:
			velocity.y += gravity.y * gravity_multiplier
			if velocity.y >= slide_terminal_velocity:
				velocity.y = slide_terminal_velocity

			var wall_dir = get_wall_collision()
			if not wall_dir:
				state = State.MOVE

	move_and_slide()
	if is_on_floor():
		has_double_jumped = false
	
	if not is_attacking() or not animation_player.is_playing():
		if is_on_floor():
			animation_player.play("run")
		else:
			animation_player.play("air")

func hit_knockback(knockback: Vector2):
	velocity = knockback.normalized() * knockback_force
	state = State.KNOCKBACK

func _move(delta):
	var motion_x = get_motion().x
	if motion_x:
		flip(motion_x < 0)

	if motion_x == 0:
		velocity.x = move_toward(velocity.x, 0, deaccel * delta)
	else:
		velocity.x = move_toward(velocity.x, motion_x * speed, accel * delta)

func get_motion():
	return Vector2(1, 0);
	# return Input.get_vector("move_left", "move_right", "move_up", "move_down")

func _unhandled_input(ev: InputEvent):
	if state != State.MOVE: return
	
	if is_on_floor() and ev.is_action_pressed("move_left"):
		velocity = Vector2.LEFT * back_move_force
		state = State.BACK_MOVE
		return

	if ev.is_action_pressed("jump"):
		#if state == State.WALL_RUN: # Wall Jump
			#var wall_n = get_wall_collision() * -1
			#if wall_n:
				#wall_n = wall_n.rotated(deg_to_rad(wall_jump_angle) * -sign(wall_n.x))
				#velocity = wall_n * wall_jump_force
				#return
		
		if is_on_floor():
			velocity.y = -jump_force
		elif not has_double_jumped:
			velocity.y = -boost_air_jump
			has_double_jumped = true

		# elif boost_available:
		# 	var motion = get_motion()
		# 	var dir = Vector2.UP * boost_jump
		# 	if motion.x != 0:
		# 		dir = dir.rotated(deg_to_rad(45 if motion.x > 0 else - 45))
		# 	velocity.y = dir.y
		# 	velocity.x += dir.x
		# 	self.boost_available = false
	elif is_on_floor() and ev.is_action_pressed("boost") and boost_available:
		# if not boost_double_tap_timeout.is_stopped():
		# if motion.x != 0:
		velocity.x = get_motion().x * boost_speed
		state = State.DASH
		self.boost_available = false
		# else:
		# 	boost_double_tap_timeout.start()
	
	if not is_attacking():
		if ev.is_action_pressed("attack"):
			animation_player.play("attack%02d" % [attack_count])
			self.attack_count += 1
			attack_count_reset.start()

func is_attacking():
	return "attack" in animation_player.current_animation

func has_boost():
	return abs(velocity.x) > speed

func flip(flipped: bool):
	collision_shape_2d.scale.x = -1 if flipped else 1

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
