extends RayCast2D

@export var nav: NavigationMove2D
@onready var player := get_tree().get_first_node_in_group("player")

func process(delta):
	look_at(player.global_position)
	
	if is_colliding():
		nav.set_target(player.global_position)
	
	nav.process(delta)

func exit():
	pass

func enter():
	pass
