class_name Player
extends CharacterBody2D

enum {
	MOVE,
	STICK,
	SWING,
	JUMP,
	PULL,
}

@export var raycast: RayCast2D
@export var ground_cast: RayCast2D

@export var sticky_delay := 0.3

@onready var gravity = ProjectSettings.get("physics/2d/default_gravity_vector") * ProjectSettings.get("physics/2d/default_gravity")
@onready var koyori_timer = $KoyoriTimer
@onready var contact = $Contact
@onready var jump_buffer = $JumpBuffer
@onready var animation_player = $AnimationPlayer
@onready var sprite_2d = $CollisionShape2D/Sprite2D

@onready var states := {
	MOVE: $States/Move,
	SWING: $States/Swing,
	STICK: $States/Stick,
	JUMP: $States/Jump,
}

var connected_point:
	set(v):
		connected_point = v
		if v:
			contact.show()
			contact.global_position = v
		else:
			contact.hide()

var state = MOVE:
	set(s):
		_get_state().exit(self)
		state = s
		_get_state().enter(self)

func _get_state(s = state):
	return states[s]
	
func _ready():
	contact.hide()
	jump_buffer.jump.connect(func(): self.state = JUMP)

func _process(delta):
	if connected_point != null:
		raycast.global_rotation = Vector2.DOWN.angle_to(global_position.direction_to(connected_point))
	else:
		var dir = global_position.direction_to(get_global_mouse_position())
		raycast.global_rotation = Vector2.DOWN.angle_to(dir)
		
func _physics_process(delta):
	_get_state().process(self, delta)
	move_and_slide()

func get_motion():
	return Input.get_vector("move_left", "move_right", "move_up", "move_down")

func _unhandled_input(ev: InputEvent):
	if ev.is_action_pressed("jump"):
		if (koyori_timer.can_jump() or connected_point != null):
			self.state = JUMP
		else:
			jump_buffer.buffer_jump()
	elif ev.is_action_pressed("attack") and raycast.is_colliding():
		self.connected_point = raycast.get_collision_point()
		self.state = SWING
	elif ev.is_action_released("attack"):
		remove_contact()
		self.state = MOVE

func remove_contact():
	self.connected_point = null

func get_contact_normal():
	return raycast.get_collision_normal()

func get_contact_distance() -> float:
	if connected_point == null:
		return 0.0
	return global_position.distance_to(connected_point)

func get_contact_direction() -> Vector2:
	if connected_point == null:
		return Vector2.ZERO
	return global_position.direction_to(connected_point)

func get_contact_point() -> Vector2:
	if connected_point == null:
		return Vector2.ZERO
	return connected_point - global_position

func flip(flipped: bool):
	sprite_2d.scale.x = -1 if flipped else 1
