extends CollisionShape2D

var parent: Area2D

func _ready() -> void:
	parent = get_parent()

func _process(delta: float) -> void:
	if parent:
		disabled = not parent.monitoring
