extends Area3D

@export var max_force := 10
@export var force_increase := 30

var pressed := false
var force := 0.0:
	set(v): force = clamp(v, 0., max_force)
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		force = 0.0
		pressed = true
	elif event.is_action_released("jump"):
		for b in get_overlapping_bodies():
			if b is Coin:
				b.apply_central_impulse(Vector3.LEFT.rotated(Vector3.FORWARD, global_rotation.z) * force)
				break
		pressed = false
		force = 0.0
		
func _process(delta: float) -> void:
	if pressed:
		self.force += force_increase * delta
