extends Node3D

@onready var package_spawner = $PackageSpawner

func _ready():
	package_spawner.spawn()
	await get_tree().create_timer(2.0).timeout
	package_spawner.spawn()
	await get_tree().create_timer(2.0).timeout
	package_spawner.spawn()
	await get_tree().create_timer(2.0).timeout
	package_spawner.spawn()
