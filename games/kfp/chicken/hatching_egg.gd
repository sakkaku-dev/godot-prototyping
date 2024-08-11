class_name HatchingEgg
extends Node2D

signal hatched()

const GROUP = "HatchingEgg"

@export var label: Label
@export var click_hatch_value := 200.
@export var hatch_value := 100.0:
	set(v):
		hatch_value = max(v, 0)
		
		var p = remap(v, 0., initial_hatch, 1., 0.)
		progress_fill.set_fill(p)
		
		if hatch_value <= 0 and not has_hatched:
			hatched.emit()
			has_hatched = true

@onready var initial_hatch := hatch_value
@onready var click_timeout: Timer = $ClickTimeout
@onready var selectable: Selectable = $Selectable
@onready var progress_fill: ProgressManualFill = $ProgressFill

var has_hatched := false
var coord := Vector2i.ZERO

func _ready():
	add_to_group(GROUP)
	selectable.clicked.connect(func(): click_timeout.start())
	self.hatch_value = hatch_value
	
	hatched.connect(func():
		KfpManager.hatch_egg(coord, global_position)
		queue_free()
	)

func _process(delta: float) -> void:
	if not click_timeout.is_stopped():
		self.hatch_value -= delta * _get_time_left_percentage()
		
	self.hatch_value -= delta * KfpManager.get_chicken_hatch_rate()
	
func _get_time_left_percentage():
	return remap(pow(click_timeout.time_left, 2), 0., pow(click_timeout.wait_time, 2) , 0., click_hatch_value)
