class_name Upgrades
extends Dialog

signal selected_upgrade(res)

@export var container: Control
@export var upgrade_scene: PackedScene

@onready var key_delegator = $KeyDelegator

func _ready():
	super._ready()
	key_reader.pressed_cancel.connect(func(_x): key_delegator.cancel())
	key_delegator.finished.connect(func(node):
		selected_upgrade.emit(node.upgrade)
		close()
	)

func show_upgrades(upgrades: Array[UpgradeResource]):
	for c in container.get_children():
		container.remove_child(c)
	key_delegator.remove_all()
	
	for up in upgrades:
		var node = upgrade_scene.instantiate()
		node.upgrade = up
		container.add_child(node)
		key_delegator.nodes.append(node)
	
	open()

func handle_key(key: String, shift: bool):
	key_delegator.handle_key(key)
