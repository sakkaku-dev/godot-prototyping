extends Control

@export var button: BaseButton
@export var close_button: BaseButton

@export var chicken_manager: ChickenManager
@export var chicken_scene: PackedScene
@export var container: Control

@onready var effect_runner = $EffectRunner

var focused_index := 0

func _ready():
	chicken_manager.chicken_changed.connect(func(_x): _update_chickens())
	button.pressed.connect(func(): effect_runner.open())
	close_button.pressed.connect(func(): effect_runner.close())

func _update_chickens():
	for c in container.get_children():
		container.remove_child(c)
		
	for i in chicken_manager.chickens.size():
		var node = chicken_scene.instantiate() as Control
		node.chicken = chicken_manager.chickens[i]
		node.focus_entered.connect(func(): self.focused_index = i)
		container.add_child(node)
		
		if focused_index == i:
			node.grab_focus()

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel") and visible and not effect_runner.is_running:
		effect_runner.close()
