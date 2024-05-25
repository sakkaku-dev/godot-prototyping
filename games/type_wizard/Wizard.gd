class_name Wizard
extends Node2D

enum Attack {
	FROST_ATTACK,
	AIR_ATTACK,
	LIGHTNING_ATTACK,
}

enum Resistance {
	FROST_RESISTANCE,
}

const GROUP = "Wizard"

signal attacks_changed(x)
signal resistance_changed(x)
signal is_casting(casting)
signal cast_spell(scroll)
signal scrolls_changed()
signal level_up()

@export var max_combo := 1000
@export var pickup_shortcut: ShortcutKey
@export var spells_shortcut: ShortcutKey
@export var castle_archer: CastleArcher

@export_category("Attacks")
@export var attack_scene: PackedScene
@export var shield_scene: PackedScene
@export var ice_zone_scene: PackedScene
@export var fireball_scene: PackedScene

@onready var hurtbox = $Hurtbox
@onready var waiting_spell = $WaitingSpell
@onready var level_manager = $LevelManager

var resistances: Array[UpgradeResourceResistance] = []
var attacks: Array[UpgradeResourceAttack] = []
var capacity := 0
var scrolls = {}

var casting := false:
	set(v):
		casting = v
		is_casting.emit(casting)

var pickup_enabled := false
var combo := 0
var next_attack

func _ready():
	add_to_group(GROUP)
	spells_shortcut.changed.connect(func(a): self.casting = a)
	level_manager.level_up.connect(func(_lvl): level_up.emit())
	
func _process(delta):
	pickup_enabled = pickup_shortcut.active

func killed_enemy(e):
	level_manager.receive_exp(e)

func attack(target: TypedCharacter):
	if next_attack:
		if target.get_remaining_word() == "":
			next_attack.fire(target)
			next_attack = null
		return
	
	var node = attack_scene.instantiate()
	node.global_position = global_position
	node.target = target
	#node.add_speed_multipler(get_combo_percentage())
	
	for atk in attacks:
		if atk.effect == null: continue
		node.effects.append(atk.effect)
	
	get_tree().current_scene.add_child(node)

func handled_key(is_valid: bool):
	if is_valid:
		combo += 1
	else:
		combo = 0

func get_combo_percentage():
	return combo / float(max_combo)
	
func add_scroll(scroll):
	if not scroll in scrolls:
		scrolls[scroll] = 0
	
	scrolls[scroll] += 1
	scrolls_changed.emit()

func do_cast(scroll: String):
	if not scroll in scrolls or scrolls[scroll] <= 0: return
	
	spells_shortcut.active = false
	scrolls[scroll] -= 1
	if scrolls[scroll] <= 0:
		scrolls.erase(scroll)
	
	cast_spell.emit(scroll)
	self.casting = false
	scrolls_changed.emit()

###################
## Spell Casting ##
###################

func cast(spell: Resource):
	if spell is ShieldResource:
		_create_spell(spell, shield_scene)
	elif spell is IceZoneResource:
		_create_spell(spell, ice_zone_scene)
	elif spell is FireballResource:
		_create_next_attack_spell(spell, fireball_scene)

func _create_spell(res: Resource, scene: PackedScene):
	var node = scene.instantiate()
	node.res = res
	get_tree().current_scene.add_child(node)
	return node

func _create_next_attack_spell(res: Resource, scene: PackedScene):
	var node = _create_spell(res, scene)
	node.global_position = waiting_spell.global_position
	next_attack = node

#######################
## Upgrade Functions ##
#######################

func upgrade(res: UpgradeResource):
	if res is UpgradeResourceValue:
		var fn = "set_%s" % res.value
		if not has_method(fn):
			print("Cannot upgrade value %s. Method not found" % res.value)
			return
		callv(fn, [res.delta])
	
	elif res is UpgradeResourceAttack:
		if res in attacks: return
		attacks.append(res)
		attacks_changed.emit(attacks)
	elif res is UpgradeResourceResistance:
		if res in resistances: return
		resistances.append(res)
		resistance_changed.emit(resistances)
	else:
		print("Unknown upgrade: %s" % res.title)
	
func set_health(v: int):
	hurtbox.max_health += v

func set_castle_archer_speedy(v: int):
	castle_archer.attack_time += v

func set_castle_archer_count(v: int):
	castle_archer.arrows += v
