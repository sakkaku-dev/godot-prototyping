extends WorkArea

@onready var work_timer = $WorkTimer
@onready var interactable = $Interactable

var working_chicken

func _ready():
	interactable.interact_started.connect(func(a: Hand):
		if not a.is_holding():
			work_timer.start_work()
			working_chicken = a
	)
	interactable.interacted.connect(func(a): work_timer.stop_work())
	work_timer.timeout.connect(func(): working_chicken.hold_item("ITEM"))
