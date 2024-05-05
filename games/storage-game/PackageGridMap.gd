class_name PackageGridMap
extends GridMap

const GROUP = "PackageGridMap"

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
		#print("Object %s is not at %s" % [obj, prev_coord])
		return false
	
	var added = add_object(new_coord, obj, true, false)
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
		
	var nodes = get_nodes_at(coord)
	if node.is_in_group(Package.GROUP) and not nodes.is_empty():
		var first = nodes[0]
		
		if first.is_in_group(Conveyer.GROUP):
			if nodes.size() > 1:
				#print("There are already items on the conveyer at %s" % coord)
				return false
		else:
			var nonPackages = nodes.filter(func(x): return not x.is_in_group(Package.GROUP))
			if nonPackages.size() > 0:
				#print("Cannot place on non-package objects: %s" % nonPackages)
				return false
	else:
		if not nodes.is_empty():
			#print("Cannot place at %s. There is already an item: %s" % [coord, nodes])
			return false
	
	if not coord in _data:
		_data[coord] = [] as Array[Node3D]
	
	if update_position:
		node.global_position = get_placement_position(coord)
	_data[coord].append(node) 
	
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
