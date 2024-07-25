extends ParallaxBackground

@export var speed := Vector2(50, 0)

func _process(delta):
	scroll_offset += speed * delta
