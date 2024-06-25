extends State

@export var jump_force := 300

func enter(p: Player):
	var dir = Vector2.UP
	p.velocity.y = dir.y * jump_force
	p.state = Player.MOVE
