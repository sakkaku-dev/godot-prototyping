extends PanelContainer

signal assign_chicken(chicken: ChickenResource)

@export var scene: PackedScene
@export var container: Control
@export var toggle_button: BaseButton

func _ready():
	hide()
	
	toggle_button.pressed.connect(func(): if visible: hide() else: show())
	_update()
	
func _update():
	for c in KfpManager.chickens:
		var node = scene.instantiate()
		node.res = c
		node.pressed.connect(func(): assign_chicken.emit(c))
		container.add_child(node)
