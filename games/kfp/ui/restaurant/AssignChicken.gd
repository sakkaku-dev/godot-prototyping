extends PanelContainer

signal assign_chicken(chicken: ChickenResource)

@export var scene: PackedScene
@export var container: Control

func _ready():
	_update()
	
func _update():
	for c in KfpManager.chickens:
		var node = scene.instantiate()
		node.res = c
		node.pressed.connect(func(): assign_chicken.emit(c))
		container.add_child(node)
