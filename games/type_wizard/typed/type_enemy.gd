class_name TypedEnemy
extends TypedCharacter

signal removed()
signal dropped(node)
signal stopped()

const ENEMY_GROUP = "TypedEnemy"

@export var enemy_res: EnemyResource
@export var drop_scene: PackedScene
@export var deaccel := 30

@onready var hit_box = $HitBox
@onready var sprite_2d = $Sprite2D
@onready var slow_timer = $SlowTimer
@onready var player: Wizard = get_tree().get_first_node_in_group(Wizard.GROUP)

var has_emitted_stop := false

var slow_amount := 0.0
var knockback := Vector2.ZERO

func _ready():
	super._ready()
	add_to_group(ENEMY_GROUP)
	finished.connect(func():
		typed_word.cancel()
		z_index = 0
	)
	hit_box.hit.connect(func(): removed.emit())
	removed.connect(func(): queue_free())
	slow_timer.timeout.connect(func():
		slow_amount = 0.0
		modulate = Color.WHITE
	)
	
	typed_word.typing.connect(func(): wizard.attack(self))
	sprite_2d.texture = enemy_res.sprite

func _process(_delta):
	typed_word.visible = not player.pickup_enabled

func _physics_process(delta):
	var dist = global_position.distance_to(Vector2.ZERO)
	if dist <= enemy_res.move_until_distance:
		if not has_emitted_stop:
			stopped.emit()
			has_emitted_stop = true
		return
		
	if knockback.length() > 0:
		velocity = knockback
		knockback = knockback.move_toward(Vector2.ZERO, delta * deaccel)
	else:
		var dir = global_position.direction_to(Vector2.ZERO)
		velocity = dir * enemy_res.speed * (1 - slow_amount) * (1 if is_on_screen() else 5)
	move_and_slide()

func hit():
	typed_word.hit += 1
	
	if typed_word.is_fully_hit():
		_maybe_drop_item(global_position)
		removed.emit()

func apply(pos: Vector2, effects: Array):
	for eff in effects:
		if eff is FrostSlowResource:
			slow_amount = eff.slow
			modulate = Color.SKY_BLUE
			slow_timer.start(eff.duration)
		elif eff is AirPushBackResource:
			var dir = pos.direction_to(global_position)
			knockback = dir * eff.push_force

func _maybe_drop_item(pos: Vector2):
	if randf() < enemy_res.drop_chance:
		var node = drop_scene.instantiate()
		node.global_position = pos
		node.set_word("scrolls")
		dropped.emit(node)

func cancel():
	typed_word.cancel()
