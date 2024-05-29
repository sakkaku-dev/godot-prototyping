class_name TypedEnemy
extends TypedCharacter

enum Type {
	PROJECTILE,
	NORMAL,
	SPAWNER,
	THROWER,
}

signal removed()
signal dropped(node)
signal stopped()
signal killed()

const ENEMY_GROUP = "TypedEnemy"

@export var enemy_res: EnemyResource
@export var drop_scene: PackedScene
@export var deaccel := 30
@export var max_burn := 100
@export var type := Type.NORMAL

@export var lightning_scene: PackedScene

@onready var effect_detector = $EffectDetector
@onready var hit_box = $HitBox
@onready var sprite_2d = $Sprite2D
@onready var slow_timer = $SlowTimer

@onready var player: Wizard = get_tree().get_first_node_in_group(Wizard.GROUP)
@onready var data: DataManager = get_tree().get_first_node_in_group(DataManager.GROUP)

var has_emitted_stop := false
var target := Vector2.ZERO

var burn_amount := 0.0:
	set(v):
		burn_amount = v
		if burn_amount >= max_burn:
			burn()

var ice_zone_slow := 0.0
var slow_amount := 0.0
var knockback := Vector2.ZERO
var last_typed

var is_finished := false

@onready var max_health := 1
@onready var health := max_health

var hit := 0:
	set(v):
		hit = v
		if hit >= max_health:
			killed.emit()
			removed.emit()

func _ready():
	_new_word()
	add_to_group(ENEMY_GROUP)

	hit_box.hit.connect(func(): removed.emit())
	removed.connect(func(): queue_free())
	slow_timer.timeout.connect(func(): slow_amount = 0.0)
	
	sprite_2d.texture = enemy_res.sprite

func finish_word():
	_new_word()

func hit_health():
	self.hit += 1

func _new_word():
	self.health -= 1
	if health >= 0:
		match type:
			Type.NORMAL: typed_word.word = data.get_random_enemy()
			Type.PROJECTILE: typed_word.word = data.get_random_projectile()
			Type.SPAWNER: typed_word.word = data.get_random_spawner_enemy()
			Type.THROWER: typed_word.word = data.get_random_throw_enemy()
	else:
		typed_word.cancel()
		typed_word.hide()
		is_finished = true

func _process(_delta):
	# typed_word.visible = not player.pickup_enabled
	
	if player:
		typed_word.focused = typed_word.word.begins_with(player.typed) and player.typed != ""
		typed_word.typed = player.typed if typed_word.focused else ""
		z_index = 20 if typed_word.focused else 0
	
	for area in effect_detector.get_overlapping_areas():
		if area.has_method("apply"):
			area.apply(self)
			
	modulate = Color.SKY_BLUE if _get_slow_amount() > 0 else Color.WHITE

func _get_slow_amount():
	return slow_amount + ice_zone_slow

func _physics_process(delta):
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
		velocity = dir * enemy_res.speed * (1 - _get_slow_amount())
		
	move_and_slide()

func auto_type(obj):
	last_typed = obj
	typed_word.auto_type()

func burn():
	burn_amount = 0

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
		dropped.emit(node)

func cancel():
	typed_word.cancel()
