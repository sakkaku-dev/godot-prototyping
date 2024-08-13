class_name HatchCountdown
extends Label

signal hatched()

@export var click_timeout: Timer
@export var click_hatch_value := 200.

@export var progress_fill: ProgressManualFill
@export var has_hatched := false:
	set(v):
		has_hatched = v
		#visible = not has_hatched
		if progress_fill:
			progress_fill.visible = not has_hatched
@export var multiplier := 1.0
@export var hatch_value := 100.0:
	set(v):
		hatch_value = max(v, 0)
		
		var p = remap(v, 0., initial_hatch, 1., 0.)
		if progress_fill:
			progress_fill.set_fill(p)
		text = "%.0f" % hatch_value
		
		if hatch_value <= 0 and not has_hatched:
			has_hatched = true
			hatched.emit()

@onready var initial_hatch := hatch_value

func _ready() -> void:
	self.hatch_value = hatch_value

func _process(delta: float) -> void:
	if has_hatched: return
	
	if click_timeout and not click_timeout.is_stopped():
		self.hatch_value -= delta * _get_time_left_percentage()
	
	self.hatch_value -= delta * KfpManager.get_chicken_hatch_rate() * multiplier
	
func _get_time_left_percentage():
	return remap(pow(click_timeout.time_left, 2), 0., pow(click_timeout.wait_time, 2) , 0., click_hatch_value)

func restart():
	has_hatched = false
	click_timeout.stop()
	self.hatch_value = initial_hatch
