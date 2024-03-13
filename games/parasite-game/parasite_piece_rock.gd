extends ParasitePiece

@onready var toggle_hit_box = $ToggleHitBox
@onready var hit_box = $HitBox

func _ready():
	super._ready()
	hit_box.type = hurtbox.type

func attack(target: Vector2):
	toggle_hit_box.attack()
	await move_to_direction(tilemap.map_to_local(target))

func moveable_tiles(center = coord):
	var x = tilemap.get_neighbors(center)
	x.append_array(tilemap.get_coords_for([Vector2i(2, 0), Vector2i(-2, 0), Vector2i(0, 2), Vector2i(0, -2)], center))
	return x
	
func attackable_tiles(center = coord):
	return tilemap.get_used_cells(tilemap.layer).filter(func(c):
		var diff = abs(c - center)
		return (c.x == center.x or c.y == center.y) and center != c and diff.x <= 3 and diff.y <= 3
	)

func _ai_move_to_player(player: ParasitePiece, moves: Array):
	return super.smallest_distance(player.coord, moves)
