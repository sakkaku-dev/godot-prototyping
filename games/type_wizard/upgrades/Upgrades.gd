extends MarginContainer

@export var container: Control
@export var upgrade_scene: PackedScene

var upgrade_nodes = {}

func show_upgrades(upgrades: Array[UpgradeResource]):
	for c in container.get_children():
		container.remove_child(c)
	upgrade_nodes.clear()
	
	for up in upgrades:
		var node = upgrade_scene.instantiate()
		node.upgrade = up
		upgrade_nodes[up.title] = node
		container.add_child(node)

func handle_key(key: String):
	pass
