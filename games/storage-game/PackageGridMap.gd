class_name PackageGridMap
extends GridMap

const GROUP = "PackageGridMap"

signal dropped_off_package()

@export var max_stack_size := 3

var _data := {}

func _ready():
	add_to_group(GROUP)

func _unhandled_input(event):
	if event.is_action_pressed("debug"):
		for c in _data:
			print("%s - %s" % [c, _data[c]])

func get_coord(pos: Vector3):
	var c = local_to_map(pos)
	return Vector3i(c.x, 0, c.z)

func move_object(prev_coord: Vector3i, new_coord: Vector3i, obj: Node3D) -> bool:
	var nodes = get_nodes_at(prev_coord)
	if not obj in nodes:
		print("Object %s is not at %s" % [obj, prev_coord])
		return false
	
	var new_nodes = get_nodes_at(new_coord)
	var added = add_object(new_coord, obj, true, not has_node_with_group(new_nodes, Conveyer.GROUP))
	if added:
		nodes.erase(obj)
	return added

func remove_object(coord: Vector3i, allow_out_of_bound := false) -> Node3D:
	if not is_valid_position(coord) and not allow_out_of_bound:
		#print("Invalid position for object at %s" % coord)
		return null
	
	if not coord in _data:
		#print("Nothing at coord %s" % coord)
		return null
		
	var nodes = get_nodes_at(coord)
	if nodes.is_empty():
		#print("No objects at %s" % coord)
		return null
		
	var last = nodes[nodes.size() - 1]
	if not last.is_in_group(Package.GROUP):
		#print("Cannot pick up non package item: %s" % last)
		return null
	
	print("Removing object at %s" % coord)
	return nodes.pop_back()

func add_object(coord: Vector3i, node: Node3D, allow_out_of_bound := false, update_position := true) -> bool:
	if not is_valid_position(coord) and not allow_out_of_bound:
		#print("Invalid position for object at %s" % coord)
		return false

	var check_weights := false
	var nodes = get_nodes_at(coord)
	if node.is_in_group(Package.GROUP) and not nodes.is_empty():
		if has_node_with_group(nodes, Conveyer.GROUP):
			if nodes.size() > 1:
				#print("There are already items on the conveyer at %s" % coord)
				return false
		elif has_node_with_group(nodes, PackageDropOff.GROUP):
			_drop_off_package(coord, node)
			return true
		else:
			var packages = nodes.filter(func(x): return x.is_in_group(Package.GROUP))
			if packages.size() != nodes.size():
				#print("Cannot place on non-package objects: %s" % nonPackages)
				return false
			
			check_weights = true
	else:
		if not nodes.is_empty():
			#print("Cannot place at %s. There is already an item: %s" % [coord, nodes])
			return false
	
	if not coord in _data:
		_data[coord] = [] as Array[Node3D]
	
	if update_position:
		node.global_position = get_placement_position(coord)
	_data[coord].append(node) 
	
	if check_weights:
		_check_breaking_packages(coord)
	
	print("Adding %s at %s" % [node.get_groups(), coord])
	return true

func _drop_off_package(coord: Vector3i, pkg: Node3D):
	pkg.queue_free()
	dropped_off_package.emit()
	print("Dropped off package at %s" % [coord])

func _check_breaking_packages(coord: Vector3i):
	var packages = _data[coord].filter(func(x): return x.is_in_group(Package.GROUP))
	print("Checking weights for %s packages" % [packages.size()])
	
	var breaking = _get_breaking_packages(packages)
	for pkg in breaking:
		pkg.break_package()
		_data[coord].erase(pkg)
		print("Breaking package %s" % pkg)

func _get_breaking_packages(packages: Array) -> Array:
	var breaking_packages := []
	for i in range(packages.size()):
		var weight_above = _get_weights_from(packages, i)
		var pkg = packages[i] as Package
		var max_weight = pkg.get_max_weight()
		print("Package %s with max weight of %s has above him %s" % [i, max_weight, weight_above])
		
		if weight_above > max_weight:
			breaking_packages.append(pkg)
	return breaking_packages

func _get_weights_from(packages: Array, idx: int) -> int:
	var weight := 0
	for i in range(idx+1, packages.size()):
		weight += packages[i].weight
	return weight

func has_node_with_group(nodes: Array, group: String) -> bool:
	return nodes.filter(func(x): return x.is_in_group(group)).size() > 0

func get_nodes_at(coord: Vector3i) -> Array[Node3D]:
	if coord in _data:
		return _data[coord]
	return []

func is_valid_position(c: Vector3i):
	var coord = Vector3(c.x, 0, c.z)
	return get_cell_item(coord) != GridMap.INVALID_CELL_ITEM

func get_placement_position(coord: Vector3i, layer = -1):
	var y = layer if layer >= 0 else get_nodes_at(coord).size()
	var pos = map_to_local(Vector3i(coord.x, y, coord.z))
	return pos

func get_position_for(node: Node3D, coord: Vector3i):
	var nodes = get_nodes_at(coord)
	var idx = nodes.find(node)
	if idx == -1:
		print("Node is not at coord %s" % coord)
		return null
	
	return get_placement_position(coord, idx)
