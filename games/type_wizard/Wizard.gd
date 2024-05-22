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

@export var attack_scene: PackedScene
@export var max_combo := 1000

@onready var hurtbox = $Hurtbox
@onready var key_reader = $KeyReader

var resistances: Array[UpgradeResourceResistance] = []
var attacks: Array[UpgradeResourceAttack] = []
var capacity := 0

var pickup_enabled := false
var combo := 0

func _ready():
	add_to_group(GROUP)
	key_reader.pressed_shift.connect(func(p): pickup_enabled = p)
	
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
