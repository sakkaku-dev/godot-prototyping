class_name PackageGridMap
extends GridMap

@export var max_stack_size := 3

var _data := {}

func _unhandled_input(event):
	if event.is_action_pressed("debug"):
		for c in _data:
			print("%s - %s" % [c, _data[c]])

func get_coord(pos: Vector3):
	var c = local_to_map(pos)
	return Vector3i(c.x, 0, c.z)

func remove_package(pos: Vector3) -> Node3D:
	var coord = get_coord(pos)
	
	if not coord in _data:
		print("Nothing at coord %s" % coord)
		return null
		
	var nodes = get_nodes_at(coord)
	
	if nodes.is_empty():
		print("No packages at %s" % coord)
		return null
		
	var last = nodes[nodes.size() - 1]
	if not last.is_in_group(Package.GROUP):
		print("Cannot pick up non package item: %s" % last)
		return null
	
	print("Removing package at %s" % coord)
	return nodes.pop_back()

func add_package(pos: Vector3, pkg: Node3D) -> bool:
	var coord = get_coord(pos)
	
	if not is_valid_position(coord):
		print("Invalid position for package at %s" % coord)
		return false
		
	var nodes = get_nodes_at(coord)
	var nonPackages = nodes.filter(func(x): return not x.is_in_group(Package.GROUP))
	
	if nonPackages.size() > 0:
		print("Cannot place on non-package objects: %s" % nonPackages)
		return false
	
	if not coord in _data:
		_data[coord] = [] as Array[Node3D]
	
	pkg.global_position = get_placement_position(coord)
	_data[coord].append(pkg)
	print("Adding package at %s" % coord)
	return true

func get_nodes_at(coord: Vector3i) -> Array[Node3D]:
	if coord in _data:
		return _data[coord]
	return []

func is_valid_position(c: Vector3i):
	var coord = Vector3(c.x, 0, c.z)
	return get_cell_item(coord) != GridMap.INVALID_CELL_ITEM

func get_placement_position(coord: Vector3i):
	var nodes = get_nodes_at(coord)
	var pos = map_to_local(Vector3i(coord.x, nodes.size(), coord.z))
	return pos
