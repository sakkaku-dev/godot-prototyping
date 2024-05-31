extends Node

@export var root_folder := "res://assets/"
@export var folder := "Models/GLTF format"
@export var output := "glb_importer"
@export var create_mesh_scene := true

func _ready():
	if not root_folder.ends_with("/"):
		root_folder += "/"
	if not folder.ends_with("/"):
		folder += "/"
	if folder.begins_with("/"):
		folder = folder.substr(1, folder.length())
	if not output.ends_with("/"):
		output += "/"
		
	DirAccess.make_dir_recursive_absolute(root_folder + output)
	
	for f in DirAccess.get_files_at(root_folder + folder):
		if f.ends_with(".import"): continue
		
		var scene = load(root_folder + folder + f) as PackedScene
		if not scene: continue
		
		var node = scene.instantiate()
		var meshes = _find_mesh_instance(node) as Array[MeshInstance3D]
		
		var file_name = f.split(".")[0]
		var root = Node3D.new()
		root.name = file_name
		for mesh in meshes:
			var m = mesh.duplicate()
			m.name = mesh.name
			root.add_child(m)
			m.owner = root
			m.create_trimesh_collision()
		
		var new_scene = PackedScene.new()
		new_scene.pack(root)
		ResourceSaver.save(new_scene, root_folder + output + file_name + ".tscn")
	
	var mesh_root = Node3D.new()
	for f in DirAccess.get_files_at(root_folder + output):
		var scene = load(root_folder + output + f) as PackedScene
		var node = scene.instantiate()
		mesh_root.add_child(node)
		node.owner = mesh_root
	
	var new_scene = PackedScene.new()
	new_scene.pack(mesh_root)
	ResourceSaver.save(new_scene, root_folder + "meshes.tscn")
	

func _find_mesh_instance(node: Node):
	if node is MeshInstance3D:
		return [node]
	
	var result = []
	for child in node.get_children():
		result.append_array(_find_mesh_instance(child))
		
	return result
