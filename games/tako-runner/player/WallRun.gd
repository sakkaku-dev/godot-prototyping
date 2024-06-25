extends State

@export var gravity_multiplier := 0.05
@export var speed_multiplier := 1.1
@export var max_speed := -200

func enter(p: Player):
	if abs(p.velocity.y) > 50 and Input.is_action_pressed("jump"):
		p.velocity.y = max(p.velocity.y * speed_multiplier, max_speed) #.rotated(p.velocity.angle_to(Vector2.UP))
		print(p.velocity.y)

func process(p: Player, delta: float):
	p.velocity += p.gravity * gravity_multiplier
	
	if p.velocity.y > 0 or not Input.is_action_pressed("jump") or not p.is_on_wall():
		p.state = Player.WALL_SLIDE if p.is_on_wall() else Player.MOVE
		return
	
