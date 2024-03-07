extends Node

@export var enemy_ratio := 0.01
@export var distance_to_player := 10
@export var enemy_spawn_distance := 4

@export var tilemap: TileMapTool
@export var enemies: Array[PackedScene] = []

func spawn():
	var player = get_tree().get_first_node_in_group("player")
	var player_pos = tilemap.local_to_map(player.global_position)
	
	for room in tilemap.get_rooms():
		var enemy_count = floor(room.size() * enemy_ratio)
		print("Spawning %s enemies" % enemy_count)
		
		var spawned_at = []
		var available_pos = room.filter(func(p): return p.distance_to(player_pos) >= distance_to_player)
		if available_pos.is_empty(): continue
		
		for _i in range(enemy_count):
			var pos = available_pos.pick_random()
			
			var node = enemies.pick_random().instantiate()
			node.global_position = tilemap.map_to_local(pos)
			tilemap.add_child(node)
			spawned_at.append(pos)
			available_pos = available_pos.filter(func(p): 
				for x in spawned_at:
					if p.distance_to(x) < enemy_spawn_distance:
						return false
				return true
			)
