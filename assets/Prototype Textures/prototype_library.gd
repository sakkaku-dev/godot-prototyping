@tool
extends Node3D

@export var run := false:
	set(v):
		do_run()

var new_mesh

func do_run():
	var shapes = []
	for node in get_children():
		if node is not CSGShape3D:
			node.queue_free()
		else:
			shapes.append(node)
	
	for node in shapes:
		node._update_shape()
		new_mesh = MeshInstance3D.new()
		new_mesh.mesh = node.get_meshes()[1]
		new_mesh.mesh.surface_set_material(0, node.material_override)
		new_mesh.visible = true
		new_mesh.create_trimesh_collision()
		add_child(new_mesh)
		new_mesh.global_position = node.global_position
		new_mesh.owner = owner
