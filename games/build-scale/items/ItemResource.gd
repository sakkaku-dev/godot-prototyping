class_name ItemResource
extends Resource

enum Type {
	Health,
	Coin,
	
	# SkillSpikes,
	# SkillGravity,
	# SkillJump,
}

@export var texture: Texture2D
@export var type: Type
