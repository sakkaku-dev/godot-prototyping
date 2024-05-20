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

@export var attack_scene: PackedScene

@onready var hurtbox = $Hurtbox

var resistance: Array[Resistance] = []
var attacks: Array[Attack] = []

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
		if res.attack in attack: return
		attacks.append(res.attack)

	elif res is UpgradeResourceResistance:
		if res.resistance in resistance: return
		resistance.append(res.resistance)
	else:
		print("Unknown upgrade: %s" % res)
	
func set_health(v: int):
	hurtbox.max_health += v

func set_castle_capacity(v: int):
	pass

func set_range(v: int):
	pass
