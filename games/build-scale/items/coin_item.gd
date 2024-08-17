class_name CoinItem
extends Area3D

const SPRITES = {
	#ItemResource.Type.Health: preload("res://icon.svg"),
	#ItemResource.Type.SkillSpikes: preload("res://icon.svg"),
	#ItemResource.Type.SkillGravity: preload("res://icon.svg"),
	#ItemResource.Type.SkillJump: preload("res://icon.svg"),
}

@onready var sprite_3d: Sprite3D = $Sprite3D

var item: ItemResource.Type

func _ready() -> void:
	sprite_3d.texture = SPRITES[item] if item in SPRITES else load("res://icon.svg")
