extends Camera2D

#@export var down_speed := 70
#@export var up_speed := 120
#@export var deaccel := 400
#@export var move_dir := Vector2.ZERO

@export var hook: Node2D

#var velocity = Vector2.ZERO
#
#func _physics_process(delta):
	#if move_dir:
		#var vel = move_dir * (down_speed if move_dir.y >= 0 else up_speed)
		#velocity = velocity.move_toward(vel, deaccel * delta)
		#translate(vel * delta)
#
#func _process(delta):
	#if Input.is_action_pressed("ui_up"):
		#global_position.y -= 1.
	#if Input.is_action_pressed("ui_down"):
		#global_position.y += 1.
	#if Input.is_action_pressed("ui_left"):
		#global_position.x -= 1.
	#if Input.is_action_pressed("ui_right"):
		#global_position.x += 1.

func _process(delta):
	global_position.y = hook.global_position.y
