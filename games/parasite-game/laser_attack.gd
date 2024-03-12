extends MeleeAttack

@export var target := Vector2(10, 0)
@export var width := 10

@onready var line_2d = $Line2D
@onready var collision_shape_2d = $CollisionShape2D

func _ready():
	super._ready()
	monitoring = false
	line_2d.points = [Vector2.ZERO, target]
	
	var rect = collision_shape_2d.shape as RectangleShape2D
	rect.size = Vector2(target.length(), width)
	collision_shape_2d.position.x = rect.size.x / 2
	
	var tw = create_tween()
	tw.tween_property(line_2d, "width", width, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	
	tw.tween_property(line_2d, "width", 0, 0.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tw.parallel().tween_callback(func(): monitoring = true)

	await tw.finished
	
	finished.emit()
	queue_free()

func set_target(x):
	target = x
