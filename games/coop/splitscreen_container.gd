class_name SplitscreenContainer
extends VBoxContainer

@export var main_viewport: SubViewport
@export var horizontal_container: Control
@export var viewport_containers: Array[SubViewportContainer] = []

func add_player(node: Node3D, count: int):
	var container = get_viewport_container(count)
	if not container:
		return
		
	if container.get_children().is_empty():
		var viewport = SubViewport.new()
		viewport.size = main_viewport.size
		viewport.world_3d = main_viewport.find_world_3d()
		container.add_child(viewport)
		container.show()
	
	container.get_child(0).add_child(node)
	
	if count > 1:
		horizontal_container.show()

func get_viewport_container(player_count: int) -> SubViewportContainer:
	if player_count >= viewport_containers.size():
		return null
		
	return viewport_containers[player_count]
