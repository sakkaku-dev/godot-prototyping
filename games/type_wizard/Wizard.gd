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

@export var attack_scene: PackedScene
@export var max_combo := 1000
@export var pickup_shortcut: ShortcutKey
@export var spells_shortcut: ShortcutKey

@onready var hurtbox = $Hurtbox

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

func _ready():
	add_to_group(GROUP)
	pickup_shortcut.changed.connect(func(a): pickup_enabled = a)
	spells_shortcut.changed.connect(func(a): self.casting = a)
	
func attack(target: TypedCharacter):
	var node = attack_scene.instantiate()
	node.global_position = global_position
	node.target = target
	node.add_speed_multipler(get_combo_percentage())
	
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

func do_cast(scroll: String):
	if not scroll in scrolls or scrolls[scroll] <= 0: return
	
	spells_shortcut.active = false
	scrolls[scroll] -= 1
	cast_spell.emit(scroll)

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

func set_castle_capacity(v: int):
	capacity += v
