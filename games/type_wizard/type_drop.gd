class_name TypedDrop
extends TypedCharacter

const DROP_GROUP = "TypedDrop"

@export var moving := false
@export var speed_multiplier := 0.5

var start_pos := Vector2.ZERO
var destination := Vector2.ZERO

func _ready():
	super._ready()
	add_to_group(DROP_GROUP)
	typed_word.type_start.connect(func():
		moving = true
		start_pos = global_position
	)
	typed_word.typing.connect(func():
		var remaining_distance = typed_word.typed.length() / float(typed_word.word.length())
		var dir = Vector2.ZERO - start_pos
		destination = start_pos + dir * remaining_distance
	)

func _physics_process(delta):
	if not moving: return
	
	var dir = start_pos.direction_to(destination)
	var dist = start_pos.distance_to(destination)
	if dist > 0.1:
		velocity = dir * dist * speed_multiplier
		move_and_slide()
