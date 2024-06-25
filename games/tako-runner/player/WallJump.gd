extends State

@export var jump_force := 400
@export var jump_angle := 60.0

func enter(p: Player):
	var wall_n = p.get_wall_collision() * -1
	if wall_n:
		wall_n = wall_n.rotated(deg_to_rad(jump_angle) * -sign(wall_n.x))
		p.velocity = wall_n * jump_force
	
	p.state = Player.MOVE
