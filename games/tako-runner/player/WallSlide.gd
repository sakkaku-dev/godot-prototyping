extends State

@export var gravity_multiplier := 0.2
@export var slide_terminal_velocity := 10
@export var leave_slide_threshold := 0.2

var leave_motion := 0.0
var face_dir: Vector2


func enter(p: Player):
	p.flip(p.get_wall_normal().x < 0)
	leave_motion = 0
	face_dir = p.get_wall_collision() * -1

func process(p: Player, delta: float):
	player.velocity += player.gravity * gravity_multiplier
	if player.velocity.y >= slide_terminal_velocity:
		player.velocity.y = slide_terminal_velocity
		
	if player.get_motion().x == face_dir.x:
		leave_motion += delta
	else:
		leave_motion = 0
	
	var moved_away_from_wall = leave_motion >= leave_slide_threshold
	if player.is_on_floor() or not player.get_wall_collision() or moved_away_from_wall:
		player.state = Player.MOVE

func handle(ev: InputEvent):
	if ev.is_action_pressed("jump"):
		player.state = Player.WALL_JUMP
