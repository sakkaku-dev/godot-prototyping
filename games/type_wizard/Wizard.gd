class_name Wizard
extends Node2D

const GROUP = "Wizard"

@export var attack_scene: PackedScene

@onready var hurtbox = $Hurtbox

func _ready():
	add_to_group(GROUP)
	
func attack(target: TypedCharacter):
	var node = attack_scene.instantiate()
	node.global_position = global_position
	node.target = target
	get_tree().current_scene.add_child(node)
