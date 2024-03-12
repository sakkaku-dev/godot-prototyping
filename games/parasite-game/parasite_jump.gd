extends CharacterBody2D

signal reached()

@onready var visible_on_screen_notifier_2d = $VisibleOnScreenNotifier2D
@onready var infect_area = $InfectArea

var from: Node2D

func _ready():
	visible_on_screen_notifier_2d.screen_exited.connect(func(): reached.emit())
	infect_area.body_entered.connect(func(a):
		if a == from: return
		
		a.infect()
		reached.emit()
	)
	
	reached.connect(func(): queue_free())
