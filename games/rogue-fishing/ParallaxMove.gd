extends ParallaxLayer

@export var speed := Vector2(100, 0)

func _process(delta):
	motion_offset += speed * delta
