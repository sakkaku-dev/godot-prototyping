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

@onready var hurtbox = $Hurtbox

var resistances: Array[UpgradeResourceResistance] = []
var attacks: Array[UpgradeResourceAttack] = []
var capacity := 0

func _ready():
	add_to_group(GROUP)
	
func attack(target: TypedCharacter):
	var node = attack_scene.instantiate()
	node.global_position = global_position
	node.target = target
	get_tree().current_scene.add_child(node)

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
