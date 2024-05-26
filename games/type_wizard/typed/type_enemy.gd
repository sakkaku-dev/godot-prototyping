class_name TypedEnemy
extends TypedCharacter

signal removed()
signal dropped(node)
signal stopped()

const ENEMY_GROUP = "TypedEnemy"

@export var enemy_res: EnemyResource
@export var drop_scene: PackedScene
@export var deaccel := 30
@export var max_burn := 100

@export var lightning_scene: PackedScene

@onready var effect_detector = $EffectDetector
@onready var hit_box = $HitBox
@onready var sprite_2d = $Sprite2D
@onready var slow_timer = $SlowTimer

@onready var ninja: TypingNinja = get_tree().get_first_node_in_group(TypingNinja.GROUP)

var has_emitted_stop := false

var burn_amount := 0.0:
	set(v):
		burn_amount = v
		if burn_amount >= max_burn:
			burn()

var ice_zone_slow := 0.0
var slow_amount := 0.0
var knockback := Vector2.ZERO
var last_typed

func _ready():
	super._ready()
	add_to_group(ENEMY_GROUP)
	finished.connect(func():
		typed_word.cancel()
		z_index = 0
	)
	hit_box.hit.connect(func(): removed.emit())
	removed.connect(func(): queue_free())
	slow_timer.timeout.connect(func(): slow_amount = 0.0)
	
	typed_word.typing.connect(func():
		if wizard:
			if last_typed and not typed_word.focused:
				if last_typed.has_method("attack"):
					last_typed.attack(self)
			else:
				wizard.attack(self)
	)
	sprite_2d.texture = enemy_res.sprite

func _process(_delta):
	if wizard:
		typed_word.visible = not wizard.pickup_enabled
	
	if ninja:
		typed_word.focused = typed_word.get_word().begins_with(ninja.typed) if ninja.typed != "" else false
		typed_word.typed = ninja.typed if typed_word.focused else ""
		z_index = 10 if typed_word.focused else 0
	
	for area in effect_detector.get_overlapping_areas():
		if area.has_method("apply"):
			area.apply(self)
			
	modulate = Color.SKY_BLUE if _get_slow_amount() > 0 else Color.WHITE

func get_target_pos():
	if ninja:
		return ninja.global_position
	
	return Vector2.ZERO

func _get_slow_amount():
	return slow_amount + ice_zone_slow

func _physics_process(delta):
	var target = get_target_pos()
	var dist = global_position.distance_to(target)
	if dist <= enemy_res.move_until_distance:
		if not has_emitted_stop:
			stopped.emit()
			has_emitted_stop = true
		return
		
	
	if knockback.length() > 0:
		velocity = knockback
		knockback = knockback.move_toward(Vector2.ZERO, delta * deaccel)
	else:
		var dir = global_position.direction_to(target)
		velocity = dir * enemy_res.speed * (1 - _get_slow_amount()) * (1 if is_on_screen() else 5)
		
	move_and_slide()

func apply_knockback(from: Vector2, force: float):
	var dir = from.direction_to(global_position)
	knockback = dir * force

func auto_type(obj):
	last_typed = obj
	typed_word.auto_type()
	
func handle_key(key: String):
	last_typed = null
	return super.handle_key(key)

func hit(obj = null):
	last_typed = obj
	typed_word.hit += 1
	
	if typed_word.is_fully_hit():
		_maybe_drop_item(global_position)
		removed.emit()

func full_hit():
	while not typed_word.is_fully_hit():
		hit()

func burn():
	burn_amount = 0
	hit()

func apply(pos: Vector2, effects: Array):
	for eff in effects:
		if eff is FrostSlowResource:
			slow_amount = eff.slow
			slow_timer.start(eff.duration)
		elif eff is AirPushBackResource:
			var dir = pos.direction_to(global_position)
			knockback = dir * eff.push_force
		elif eff is LightningEffectResource:
			var node = lightning_scene.instantiate()
			node.res = eff
			node.global_position = global_position
			node.current.append(self)
			get_tree().current_scene.add_child(node)

func _maybe_drop_item(pos: Vector2):
	if randf() < enemy_res.drop_chance:
		var node = drop_scene.instantiate()
		node.global_position = pos
		node.set_word("scrolls")
		dropped.emit(node)

func cancel():
	typed_word.cancel()

func reset():
	typed_word.reset()
