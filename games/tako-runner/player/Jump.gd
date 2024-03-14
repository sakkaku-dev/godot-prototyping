extends State

@export var jump_force := 300

func enter(p: Player):
	var dir = Vector2.UP
	var motion_x = p.get_motion().x
	var normal = p.get_contact_normal()
	
	if p.is_on_wall() and normal.dot(Vector2(motion_x, 0)) > 0:
		dir = dir + Vector2(motion_x, 0)
		
	p.remove_contact()
	p.velocity.y = dir.y * jump_force
	p.state = Player.MOVE
