extends State

@export var speed := 300
@export var sprint_speed := 500
@export var accel := 1200

var sprinting := false

func process(p: Player, delta: float):
	var motion_x = p.get_motion().x
	if motion_x:
		p.flip(motion_x < 0)

	var s = sprint_speed if sprinting else speed
	p.velocity.x = move_toward(p.velocity.x, motion_x * s, accel * delta)
	p.velocity += p.gravity
	
	if not p.is_on_floor() and p.is_moving_against_wall():
		p.state = Player.WALL_SLIDE

func handle(ev: InputEvent):
	if ev.is_action_pressed("jump") and player.is_on_floor():
		player.state = Player.JUMP
	
	if ev.is_action_pressed("slide") and player.is_on_floor():
		player.state = Player.SLIDE

	if ev.is_action("sprint"):
		sprinting = ev.is_pressed() and player.is_on_floor()
