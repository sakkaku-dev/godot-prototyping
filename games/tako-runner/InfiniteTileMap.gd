extends TileMap

@export var ground_height := 16
@export var ground_width := 200
@export var atlas_tile := Vector2i(0, 2)
@export var tile_source := 2

@onready var visible_on_screen_notifier_2d = $VisibleOnScreenNotifier2D

func _ready():
	visible_on_screen_notifier_2d.screen_entered.connect(func():
		var coord = local_to_map(visible_on_screen_notifier_2d.global_position)
		for x in ground_width:
			for y in ground_height:
				set_cell(0, coord + Vector2i(x, y), tile_source, atlas_tile)
		
		visible_on_screen_notifier_2d.global_position = map_to_local(coord + Vector2i(ground_width - 5, 0))
	)
