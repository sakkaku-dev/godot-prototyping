class_name Player
extends CharacterBody2D

enum {
	MOVE,
	JUMP,
	WALL_JUMP,
	WALL_SLIDE,
	SLIDE,
}

@onready var gravity = ProjectSettings.get("physics/2d/default_gravity_vector") * ProjectSettings.get("physics/2d/default_gravity")
@onready var koyori_timer = $KoyoriTimer
@onready var jump_buffer = $JumpBuffer
@onready var animation_player = $AnimationPlayer
@onready var sprite_2d = $CollisionShape2D/Sprite2D
@onready var right_wall_cast = $CollisionShape2D/RightWallCast
@onready var left_wall_cast = $CollisionShape2D/LeftWallCast

@onready var states := {
	MOVE: $States/Move,
	JUMP: $States/Jump,
	WALL_JUMP: $States/WallJump,
	WALL_SLIDE: $States/WallSlide,
	SLIDE: $States/Slide,
}

var state = MOVE:
	set(s):
		if state == s: return
		_get_state().exit(self)
		state = s
		_get_state().enter(self)
		
		#match s:
			#MOVE: print("MOVE")
			#JUMP: print("JUMP")
			#WALL_JUMP: print("WALL_JUMP")
			#WALL_SLIDE: print("WALL_SLIDE")

func _get_state(s = state):
	return states[s]
	
#func _ready():
	#jump_buffer.jump.connect(func(): self.state = JUMP)

func _physics_process(delta):
	_get_state().process(self, delta)
	move_and_slide()

func get_motion():
	return Input.get_vector("move_left", "move_right", "move_up", "move_down")

func _unhandled_input(ev: InputEvent):
	_get_state().handle(ev)
	#if ev.is_action_pressed("jump"):
		#if koyori_timer.can_jump():
			#self.state = JUMP
		#else:
			#jump_buffer.buffer_jump()

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
