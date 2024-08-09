extends Node2D

@onready var control: Control = $Control
@onready var autopickup_timer: Timer = $AutopickupTimer

var amount := 0

func _ready() -> void:
	control.mouse_entered.connect(_pickup)
	autopickup_timer.timeout.connect(_pickup)

func _pickup():
	KfpManager.add_item(KfpUpgradeManager.EGG, amount)
	queue_free()
