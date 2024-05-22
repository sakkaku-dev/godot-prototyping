class_name TypedDrop
extends TypedCharacter

const DROP_GROUP = "TypedDrop"

@export var moving := false
@export var speed_multiplier := 0.5

@onready var sprite_2d = $Sprite2D
@onready var player: Wizard = get_tree().get_first_node_in_group(Wizard.GROUP)

var start_pos := Vector2.ZERO
var destination := Vector2.ZERO

var highlight := false:
	set(v):
		highlight = v
		z_index = 20 if highlight else 0
		sprite_2d.material.set_shader_parameter("enable", highlight)

func _ready():
	super._ready()
	add_to_group(DROP_GROUP)
	
	self.highlight = false
	sprite_2d.material = sprite_2d.material.duplicate()
	
	typed_word.type_start.connect(func():
		moving = true
		start_pos = global_position
	)
	typed_word.typing.connect(func():
		var remaining_distance = typed_word.typed.length() / float(typed_word.word.length())
		var dir = Vector2.ZERO - start_pos
		destination = start_pos + dir * remaining_distance
	)

func _process(_delta):
	self.highlight = player.pickup_enabled

func _physics_process(delta):
	if not moving: return
	
	var dir = start_pos.direction_to(destination)
	var dist = start_pos.distance_to(destination)
	if dist > 0.1:
		velocity = dir * dist * speed_multiplier
		move_and_slide()
