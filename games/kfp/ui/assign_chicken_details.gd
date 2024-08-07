extends ChickenDetails

var showing: ChickenResource

func _ready() -> void:
	super._ready()

func _process(delta: float) -> void:
	visible = KfpManager.assigning_chicken != null
	if visible and showing != KfpManager.assigning_chicken:
		show_chicken(KfpManager.assigning_chicken)
		showing = KfpManager.assigning_chicken
