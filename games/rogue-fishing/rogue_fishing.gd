extends Node2D

@export var hook_scene: PackedScene
@export var player_body: Node2D
@export var collect_area: CollectArea
@export var camera_2d: Camera2D

@export var caught_fish_dialog: CaughtFishDialog
@export var money_label: Label

var previous_map: MapTileArea
var hook: Hook

func _ready():
	InputMapper.override_key_inputs({
		"move_left": KEY_A,
		"move_right": KEY_D,
		"move_up": KEY_W,
		"move_down": KEY_S,
		"action": KEY_SPACE,
	})

	collect_area.caught_fish.connect(func(fish):
		if fish.is_empty(): return
		caught_fish_dialog.show_fish(fish)
	)
	_reset_camera_pos()

func _reset_camera_pos():
	camera_2d.move_dir = Vector2.ZERO
	camera_2d.global_position = player_body.global_position + Vector2.DOWN

func _unhandled_input(event):
	if event.is_action_pressed("action") and hook == null:
		camera_2d.move_dir = Vector2.DOWN
		
		hook = hook_scene.instantiate()
		hook.start_reel.connect(func():
			camera_2d.move_dir = Vector2.UP
		)
		hook.caught.connect(func():
			hook = null
			_reset_camera_pos()
		)
		camera_2d.add_child(hook)
		hook.set_start_position(player_body.global_position)
