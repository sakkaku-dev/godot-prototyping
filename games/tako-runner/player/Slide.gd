extends State

@export var slide_speed := 300
@export var slide_deacceleration := 800
@export var slide_threshold := 0.1

var motion := Vector2.ZERO

func enter(_p):
	motion = player.get_face_dir() * slide_speed
	
func process(_p, delta: float):
	motion = motion.move_toward(Vector2.ZERO, slide_deacceleration * delta)
	player.velocity.x = motion.x
	player.velocity.y = Vector2.DOWN.y * 10 # move down so is_on_floor() stays true

	if abs(motion.x) <= slide_threshold or not player.is_on_floor():
		player.state = Player.MOVE

func handle(ev: InputEvent):
	if ev.is_action_pressed("jump"):
		player.state = Player.JUMP
