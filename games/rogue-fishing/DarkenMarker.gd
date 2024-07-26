extends Marker2D


func _process(delta):
	var player_pos = to_local(player.global_position)
	if player_pos.y < 0:
		canvas_mod.color = from_color
		return
	
	var dist = player_pos.distance_to(max_pos)
	if player_pos.y <= max_pos.y:
		var p = 1. - remap(dist, 0., max_pos.y, 0., 1.)
		canvas_mod.color = from_color.lerp(to_color, p)
	else:
		canvas_mod.color = to_color
