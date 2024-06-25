extends State

@export var speed := 300
@export var accel := 400

func process(p: Player, delta: float):
	if p.is_on_floor():
		p.state = Player.MOVE
		return
		
	if p.is_moving_against_wall():
		p.state = Player.WALL_RUN if p.velocity.y < 0 else Player.WALL_SLIDE
		return
	
	var motion_x = p.get_motion().x
	
	if motion_x:
		p.flip(motion_x < 0)

	p.velocity.x = move_toward(p.velocity.x, motion_x * speed, accel * delta)
	p.velocity += p.gravity
