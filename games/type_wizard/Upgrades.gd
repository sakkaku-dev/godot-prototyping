class_name Upgrades
extends Dialog

signal selected_upgrade(res)

@export var container: Control
@export var upgrade_scene: PackedScene

var upgrade_nodes = {}
var current_node

func _ready():
	super._ready()
	key_reader.pressed_cancel.connect(_cancel)

func show_upgrades(upgrades: Array[UpgradeResource]):
	for c in container.get_children():
		container.remove_child(c)
	upgrade_nodes.clear()
	
	for up in upgrades:
		var node = upgrade_scene.instantiate()
		node.upgrade = up
		node.finished.connect(func(): 
			selected_upgrade.emit(up)
			close()
		)
		upgrade_nodes[up.title] = node
		container.add_child(node)
	
	open()

func handle_key(key: String, shift: bool):
	if not current_node:
		for title in upgrade_nodes:
			if title.begins_with(key):
				current_node = upgrade_nodes[title]
				break
			
	if current_node:
		current_node.handle_key(key)

func _cancel():
	if not current_node: return
	
	current_node.cancel()
	current_node = null
