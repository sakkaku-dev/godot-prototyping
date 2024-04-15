extends PanelContainer

@export var button: BaseButton
@export var close_button: BaseButton

@export var chicken_manager: ChickenManager
@export var chicken_scene: PackedScene
@export var container: Control

@onready var position_effect = $PositionEffect
@onready var overlay_effect = $OverlayEffect

@onready var effects = [position_effect, overlay_effect]

func _ready():
	chicken_manager.chicken_changed.connect(func(_x): _update_chickens())
	button.pressed.connect(func(): _open())
	close_button.pressed.connect(func(): _close())

func _open():
	for e in effects:
		e.open()
		
func _close():
	for e in effects:
		e.close()

func _update_chickens():
	for c in container.get_children():
		container.remove_child(c)
		
	for chicken in chicken_manager.chickens:
		var node = chicken_scene.instantiate()
		container.add_child(node)
