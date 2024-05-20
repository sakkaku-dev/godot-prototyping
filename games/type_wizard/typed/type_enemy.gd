class_name TypedEnemy
extends TypedCharacter

signal removed()
signal dropped(node)
signal stopped()

const ENEMY_GROUP = "TypedEnemy"

@export var enemy_res: EnemyResource
@export var drop_scene: PackedScene

@onready var hit_box = $HitBox
@onready var sprite_2d = $Sprite2D

var has_emitted_stop := false

func _ready():
	super._ready()
	add_to_group(ENEMY_GROUP)
	finished.connect(func(): typed_word.cancel())
	hit_box.hit.connect(func(): removed.emit())
	removed.connect(func(): queue_free())
	
	typed_word.typing.connect(func(): wizard.attack(self))
	sprite_2d.texture = enemy_res.sprite

func _physics_process(delta):
	var dist = global_position.distance_to(Vector2.ZERO)
	if dist <= enemy_res.move_until_distance:
		if not has_emitted_stop:
			stopped.emit()
			has_emitted_stop = true
		return
		
	var dir = global_position.direction_to(Vector2.ZERO)
	velocity = dir * enemy_res.speed
	move_and_slide()

func hit():
	typed_word.hit += 1
	if typed_word.is_fully_hit():
		_maybe_drop_item(global_position)
		removed.emit()

func _maybe_drop_item(pos: Vector2):
	if randf() < enemy_res.drop_chance:
		var node = drop_scene.instantiate()
		node.global_position = pos
		node.set_word("scrolls")
		dropped.emit(node)

func cancel():
	typed_word.cancel()
