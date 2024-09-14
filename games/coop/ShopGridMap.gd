class_name ShopGridMap
extends GridMap

@export var root: NavigationRegion3D

var data = {}

func place(pos: Vector3i, obj: Node3D):
	if pos in data:
		print("Already an object at %s" % pos)
		return
	
	if get_cell_item(pos) != INVALID_CELL_ITEM:
		print("Already a tile at %s" % pos)
		return
	
	data[pos] = obj
	root.add_child(obj)
	obj.global_position = map_to_local(pos)
	
	await get_tree().create_timer(0.1).timeout
	root.bake_navigation_mesh()

func remove(pos: Vector3i):
	if not pos in data:
		print("Nothing to remove at %s" % pos)
		return
		
	var obj = data[pos]
	root.remove_child(obj)
	data.erase(pos)
