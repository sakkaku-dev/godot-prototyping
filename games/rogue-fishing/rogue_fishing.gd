extends Node2D

@export var hook_scene: PackedScene
@export var player_body: Node2D
@export var collect_area: CollectArea

@export var hook: Hook
@export var caught_fish_dialog: CaughtFishDialog
@export var money_label: Label

var previous_map: MapTileArea

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
	
	hook.caught.connect(func():
		_reset_camera_pos()
	)

func _reset_camera_pos():
	hook.global_position = player_body.global_position + Vector2.DOWN

func _unhandled_input(event):
	if event.is_action_pressed("action") and not hook.visible:
		hook.start_move(player_body.global_position)
