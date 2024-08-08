class_name TimedWorkArea
extends WorkArea

@export var work_timer: WorkTimer
@export var exhaustion_increase_rate := 1.0
@export var exhaustion_decrease_rate := 1.0

var exhaustion := 0.0:
	set(v):
		exhaustion = clamp(v, 0.0, 100.0)
		if exhaustion >= 100:
			print("Reached burnout")

func _ready():
	super._ready()
	interact.interacted.connect(func(a): work_timer.stop_work())
	work_timer.timeout.connect(func(): work_finished.emit())

func do_action(hand: Hand):
	if can_work(hand):
		work_timer.start_work(worker)

func can_work(hand: Hand):
	return true

func _process(delta: float) -> void:
	if not work_timer.is_stopped():
		self.exhaustion += delta * exhaustion_increase_rate * ChickenTraits.get_multiplier(worker.traits, ChickenTraits.get_exhaustion_multiplier)
	else:
		self.exhaustion -= delta * exhaustion_decrease_rate
