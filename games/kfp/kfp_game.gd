extends Node2D

@export var customer_scene: PackedScene

@onready var customer_timer = $CustomerTimer
@onready var customer_spawn: Node2D = get_tree().get_first_node_in_group("spawn")

func _ready():
	KfpManager.assigned_chickens = []
	customer_timer.timeout.connect(_spawn_customer)

func _spawn_customer():
	var node = customer_scene.instantiate()
	node.global_position = customer_spawn.global_position
	add_child(node)

func _on_start_button_pressed():
	customer_timer.random_start()

func _on_farm_button_pressed():
	get_tree().change_scene_to_file("res://games/kfp/rooms/farm.tscn")

func _on_assign_chicken_assign_chicken(chicken):
	KfpManager.assigning_chicken = chicken
