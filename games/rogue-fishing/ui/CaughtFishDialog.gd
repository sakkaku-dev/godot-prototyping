class_name CaughtFishDialog
extends Control

@export var row_scene: PackedScene
@export var container: Control
@export var aquarium_container: Control
@export var done_btn: BaseButton

func _ready():
	hide()
	
	done_btn.pressed.connect(func():
		var add = []
		var selling = []
		var remove = []
		
		for child in container.get_children():
			if child.is_selling():
				selling.append(child.fish)
			else:
				add.append(child.fish)
				
		for child in aquarium_container.get_children():
			if child.is_selling():
				selling.append(child.fish)
				remove.append(child.fish)
		
		for f in selling:
			DeepwaterGame.money += f.price
		DeepwaterGame.update_fish_to_aquarium(add, remove)
		hide()
	)

func show_fish(fish: Array):
	print("Caught fish %s" % [fish])
	for c in container.get_children():
		c.queue_free()
	
	show()
	for f in fish:
		var node = row_scene.instantiate()
		node.fish = f
		container.add_child(node)

	add_aquarium_fish()

func add_aquarium_fish():
	for c in aquarium_container.get_children():
		c.queue_free()
		
	for f in DeepwaterGame.aquarium:
		var node = row_scene.instantiate()
		node.fish = f
		aquarium_container.add_child(node)
