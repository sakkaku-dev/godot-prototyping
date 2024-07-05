extends Node2D

@export var hook_scene: PackedScene
@export var player_body: Node2D
@export var collect_area: CollectArea

@export_category("Map Areas")
@export var single_area_size := 1000
@export var num_of_areas := 8
@export var generate_offset := Vector2(0, -200)
@export var all_map_areas: Array[MapResource] = []
@export var map_create_point: VisibleOnScreenNotifier2D
@export var map_root: Node2D

@onready var map_areas: Array[MapResource] = Util.pick_random(all_map_areas, num_of_areas)
@onready var camera_2d = $Camera2D

var fishes: Array[FishResource] = []
var previous_map: MapTileArea
var hook: Hook

func _ready():
	InputMapper.override_key_inputs({
		"move_left": KEY_A,
		"move_right": KEY_D,
		"action": KEY_SPACE,
	})

	collect_area.caught_fish.connect(func(fish): fishes.append(fish))
	map_create_point.screen_entered.connect(_add_next_map_section)
	map_create_point.global_position = map_root.global_position + generate_offset

func _process(delta):
	camera_2d.global_position.y = hook.global_position.y if hook else player_body.global_position.y

func _unhandled_input(event):
	if event.is_action_pressed("action") and hook == null:
		hook = hook_scene.instantiate()
		hook.global_position = player_body.global_position
		hook.caught.connect(func():
			hook = null
			collect_area.set_deferred("monioring", false)
		)
		get_tree().current_scene.add_child(hook)
		await get_tree().create_timer(1.0).timeout
		collect_area.monitoring = true
		hook.can_move_up = true

func _add_next_map_section():
	var map_res = _get_map_area_for(map_create_point.global_position - generate_offset + Vector2.DOWN * 5)
	var tile = map_res.sections.pick_random().instantiate() as MapTileArea
	
	map_root.add_child(tile)
	tile.global_position = previous_map.get_last_position() if previous_map else map_root.global_position
	map_create_point.global_position = tile.get_last_position() + generate_offset
	
	previous_map = tile

	
func _get_map_area_for(current_pos: Vector2) -> MapResource:
	var pos = current_pos - map_root.global_position
	var idx = floor(pos.y / single_area_size)
	if idx >= 0 and idx < len(map_areas):
		return map_areas[idx]

	return map_areas[len(map_areas) - 1]
