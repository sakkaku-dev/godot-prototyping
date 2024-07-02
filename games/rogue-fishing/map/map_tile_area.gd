class_name MapTileArea
extends TileMap

const fish_scene: PackedScene = preload("res://games/rogue-fishing/fish.tscn")

@export var max_move_size := Vector2(400, 50)
@export var min_fish_count := 10
@export var max_fish_count := 20
@export var fishes: Array[FishResource] = []
@export var map_area: Area2D
@export var end_marker: Marker2D

func _ready():
	_spawn_fishes()

func _spawn_fishes():
	fishes.shuffle()
	var spawn_rect = map_area.get_node("CollisionShape2D").shape as RectangleShape2D
	var shape_rect = spawn_rect.get_rect()
	var rect = Rect2(map_area.global_position - shape_rect.size / 2, shape_rect.size)
	
	for i in randi_range(min_fish_count, max_fish_count):
		var node = fish_scene.instantiate() as Fish
		node.fish = fishes[i % len(fishes)]

		var x = randi_range(rect.position.x, rect.position.x+rect.size.x)
		var y = randi_range(rect.position.y, rect.position.y+rect.size.y)
		node.position = Vector2(x, y)

		var move_rect = Rect2(Vector2(0, node.global_position.y - max_move_size.y / 2), max_move_size)
		node.move_area = move_rect
		add_child(node)

func get_last_position():
	return Vector2(0, end_marker.global_position.y)
