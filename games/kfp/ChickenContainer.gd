extends PanelContainer

@export var button: BaseButton
@export var close_button: BaseButton

@export var chicken_manager: ChickenManager
@export var chicken_scene: PackedScene
@export var container: Control

@onready var position_effect = $PositionEffect

func _ready():
	chicken_manager.chicken_changed.connect(func(_x): _update_chickens())
	button.pressed.connect(func(): position_effect.open())
	close_button.pressed.connect(func(): position_effect.close())
	
func _update_chickens():
	for c in container.get_children():
		container.remove_child(c)
		
	for chicken in chicken_manager.chickens:
		var node = chicken_scene.instantiate()
		container.add_child(node)
