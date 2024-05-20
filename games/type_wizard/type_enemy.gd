class_name TypedEnemy
extends TypedCharacter

signal removed()
signal dropped(node)

const ENEMY_GROUP = "TypedEnemy"

@export var speed := 10
@export var drop_chance := 0.1
@export var drop_scene: PackedScene
@export var enemy_spawn_distance_from_player := 250

@onready var hit_box = $HitBox
@onready var center_move = $CenterMove

func _ready():
	super._ready()
	add_to_group(ENEMY_GROUP)
	finished.connect(func():
		typed_word.reset()
		typed_word.modulate = Color.DIM_GRAY
	)
	hit_box.hit.connect(func(): removed.emit())
	removed.connect(func(): queue_free())
	
	typed_word.typing.connect(func(): wizard.attack(self))
	global_position = (Vector2.RIGHT * enemy_spawn_distance_from_player).rotated(randf_range(0, TAU))

func _physics_process(delta):
	var dir = global_position.direction_to(Vector2.ZERO)
	velocity = dir * speed
	move_and_slide()

func hit():
	typed_word.hit += 1
	if typed_word.is_fully_hit():
		_maybe_drop_item(global_position)
		removed.emit()

func _maybe_drop_item(pos: Vector2):
	if randf() < drop_chance:
		var node = drop_scene.instantiate()
		node.global_position = pos
		node.set_word("scrolls")
		dropped.emit(node)
