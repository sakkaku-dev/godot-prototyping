class_name DataGridMap
extends GridMap

@export var root: Node3D

var data = {}

func place(pos: Vector3i, obj: Node3D):
	if pos in data:
		print("Already an object at %s" % pos)
		return
	
	data[pos] = obj
	root.add_child(obj)
	obj.global_position = map_to_local(pos)

func remove(pos: Vector3i):
	if not pos in data:
		print("Nothing to remove at %s" % pos)
		return
		
	var obj = data[pos]
	root.remove_child(obj)
	data.erase(pos)
	
