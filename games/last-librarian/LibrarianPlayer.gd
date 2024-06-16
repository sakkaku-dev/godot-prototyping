extends CharacterBody2D

@export var speed := 100
@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var sprite_2d = $Sprite2D
@onready var hand = $Hand

func _physics_process(_delta):
	var motion = get_motion()
	velocity.x = motion * speed
	
	if motion:
		sprite_2d.scale.x = -1 if motion < 0 else 1
	
	if not is_on_floor():
		velocity += Vector2.DOWN * gravity
	
	move_and_slide()

func get_motion():
	return Input.get_axis("move_left", "move_right")

func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		hand.interact()
