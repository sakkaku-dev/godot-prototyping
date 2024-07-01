extends Node2D

@export var hook_scene: PackedScene
@export var player_body: Node2D
@export var collect_area: CollectArea

@export_category("Map Areas")
@export var single_area_size := 1000
@export var num_of_areas := 8
@export var generate_tiles_before := 5
@export var all_map_areas: Array[MapResource] = []
@export var map_create_point: VisibleOnScreenNotifier2D
@export var map_root: Node2D

@onready var map_areas: Array[MapResource] = Util.pick_random(all_map_areas, num_of_areas)
@onready var phantom_camera_2d = $PhantomCamera2D

var fishes: Array[FishResource] = []
var current_map: TileMap
var hook: Hook

func _ready():
	InputMapper.override_key_inputs({
		"move_left": KEY_A,
		"move_right": KEY_D,
		"action": KEY_SPACE,
	})

	collect_area.caught_fish.connect(func(fish): fishes.append(fish))
	map_create_point.screen_entered.connect(_add_next_map_section)

func _unhandled_input(event):
	if event.is_action_pressed("action") and hook == null:
		hook = hook_scene.instantiate()
		hook.global_position = player_body.global_position
		hook.caught.connect(func():
			phantom_camera_2d.follow_target = player_body
			hook = null
			collect_area.monitoring = false
		)
		get_tree().current_scene.add_child(hook)
		phantom_camera_2d.follow_target = hook
		await get_tree().create_timer(1.0).timeout
		collect_area.monitoring = true

func _add_next_map_section():
	var map_res = _get_current_map_area()
	var tile = map_res.tiles.pick_random().instantiate() as MapTileArea
	tile.fishes = map_res.fishes.duplicate()

	var size_y = tile.get_used_rect().size.y
	var actual_size = tile.map_to_local(Vector2i(0, size_y))
	tile.position.y = actual_size.y

	if current_map == null:
		map_root.add_child(tile)
	else:
		current_map.add_child(tile)
	current_map = tile

	map_create_point.global_position = tile.map_to_local(Vector2i(0, size_y - generate_tiles_before))

	
func _get_current_map_area() -> MapResource:
	var idx = floor(map_create_point.global_position.y / single_area_size)
	if idx >= 0 and idx < len(map_areas):
		return map_areas[idx]

	return map_areas[len(map_areas) - 1]
