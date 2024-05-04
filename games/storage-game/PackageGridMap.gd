class_name PackageGridMap
extends GridMap

@export var max_stack_size := 3

#var _cache := {}

#func add_package(coord: Vector3i, pkg: Node3D):
	#if not coord in _cache:
		#_cache[coord] = []
	#
	#if _cache[coord].size() >= max_stack_size:
		#print("Coord %s stack is already full" % coord)
		#return false
	#
	#_cache[coord].append(pkg)
	#return true

func get_packages(pos: Vector3) -> Array[Node3D]:
	#if not coord in _cache: return []
	#return _cache[coord]
	
	var coord = local_to_map(pos)
	var result: Array[Node3D] = []
	for pkg in get_tree().get_nodes_in_group(Package.GROUP):
		if pkg.holding: continue
		
		var c = local_to_map(pkg.global_position)
		if c == coord:
			result.append(pkg)
	
	result.sort_custom(func(a, b): return a.global_position.y < b.global_position.y)
	return result

func is_valid_position(pos: Vector3):
	var coord = local_to_map(pos)
	return get_cell_item(coord) != GridMap.INVALID_CELL_ITEM

func get_placement_position(pos: Vector3, layer_offset := 0):
	var packages = get_packages(pos)
	var coord = local_to_map(pos)
	return map_to_local(Vector3i(coord.x, packages.size() + layer_offset, coord.z))
