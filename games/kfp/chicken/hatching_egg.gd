class_name HatchingEgg
extends Node2D

signal hatched()

const GROUP = "HatchingEgg"

@onready var countdown: HatchCountdown = $Countdown
@onready var click_timeout: Timer = $ClickTimeout
@onready var selectable: Selectable = $Selectable
@onready var progress_fill: ProgressManualFill = $ProgressFill
@onready var tilemap: TileMapLayer= get_tree().get_first_node_in_group("map")
@onready var coord = tilemap.local_to_map(global_position)

var has_hatched := false

func _ready():
	add_to_group(GROUP)
	selectable.clicked.connect(func(): click_timeout.start())
	
	countdown.hatched.connect(func():
		KfpManager.hatch_egg(coord, global_position)
		queue_free()
	)
	
	KfpManager.start_hatching(coord, countdown.hatch_value)
