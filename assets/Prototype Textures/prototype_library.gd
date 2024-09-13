@tool
extends Node3D

var new_mesh

func _ready():
	for node in get_children():
		if node is CSGShape3D:
			node._update_shape()
			new_mesh = MeshInstance3D.new()
			new_mesh.mesh = node.get_meshes()[1]
			new_mesh.mesh.surface_set_material(0, node.material_override)
			new_mesh.visible = false
			new_mesh.create_trimesh_collision()
			add_child(new_mesh)
