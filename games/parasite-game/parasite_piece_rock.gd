extends ParasitePiece

@onready var ray_cast_2d = $RayCast2D
@onready var toggle_hit_box = $ToggleHitBox
@onready var hit_box = $HitBox

func _ready():
	super._ready()
	hit_box.type = hurtbox.type

func attack(target: Vector2):
	ray_cast_2d.target_position = target - global_position
	ray_cast_2d.force_raycast_update()
	
	var x = ray_cast_2d.get_collider()
	
	var return_coord = null
	var attack_coord = tilemap.local_to_map(target)
	if x:
		print("Attacking %s at %s" % [x, x.coord])
		attack_coord = x.coord
		return_coord = x.coord - Vector2i(ray_cast_2d.target_position.normalized())
	
	var tw = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tw.tween_property(self, "global_position", tilemap.map_to_local(attack_coord), 0.5)
	if return_coord != null:
		tw.tween_property(self, "global_position", tilemap.map_to_local(return_coord), 0.5)
	
	toggle_hit_box.attack()
	await tw.finished
	
	return attack_coord if return_coord == null else return_coord

func moveable_tiles(tilemap: FixedTileMap):
	return tilemap.get_coords_for(FixedTileMap.DIAGONAL_NEIGHBORS, coord)
	
func attackable_tiles(tilemap: FixedTileMap):
	return tilemap.get_used_cells(tilemap.layer).filter(func(c):
		var diff = abs(c - coord)
		return (c.x == coord.x or c.y == coord.y) and coord != c and diff.x <= 3 and diff.y <= 3
	)
