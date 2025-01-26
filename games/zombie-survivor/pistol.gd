class_name Gun
extends RayCast3D

@export var damage := 1
@export var firerate_timer: Timer

func fire():
	if not firerate_timer.is_stopped(): return
	
	firerate_timer.start()
	if is_colliding():
		var hurt_box = get_collider()
		hurt_box.damage(damage, global_position)
