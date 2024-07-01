class_name MapTileArea
extends TileMap

const fish_scene: PackedScene = preload("res://games/rogue-fishing/fish.tscn")

@export var min_fish_count := 10
@export var max_fish_count := 20
@export var fishes: Array[FishResource] = []

func _ready():
	_spawn_fishes()

func _spawn_fishes():
	fishes.shuffle()
	for i in randi_range(min_fish_count, max_fish_count):
		var node = fish_scene.instantiate() as Fish
		node.fish = fishes[i % len(fishes)]

		var rect = get_used_rect()
		var size = tile_set.tile_size
		node.move_area = Rect2(rect.position * size, rect.size * size)
		var c = get_used_cells(0).pick_random()
		node.position = map_to_local(c)
		add_child(node)
