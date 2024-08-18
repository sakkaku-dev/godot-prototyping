extends Area3D

@export var max_force := 25
@export var force_increase := 50

@export var min_volume := -25
@export var max_volume := -10
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

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
				var dir = Vector3.LEFT.rotated(Vector3.FORWARD, global_rotation.z)
				print(dir)
				b.apply_central_impulse(dir * force)
				audio_stream_player.volume_db = remap(force, 0, max_force, min_volume, max_volume)
				audio_stream_player.play()
				break
		pressed = false
		force = 0.0
		
func _process(delta: float) -> void:
	if pressed:
		self.force += force_increase * delta
