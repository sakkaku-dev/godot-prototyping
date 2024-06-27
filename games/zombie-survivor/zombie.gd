extends CharacterBody2D

@onready var hurtbox = $Hurtbox
@onready var navigation_move_2d = $NavigationMove2D

var target: Node2D

func _ready():
	hurtbox.died.connect(func(): queue_free())

func _physics_process(delta):
	if target:
		navigation_move_2d.set_target(target.global_position)
	
	navigation_move_2d.process(delta)
