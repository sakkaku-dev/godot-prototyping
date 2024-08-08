class_name ChickenTraits

enum Type {
	LAZY,
	DILIGENT,
	PERFECTIONIST,
	SLOPPY,
	CHARMING,
	NERVOUS,
	TEAM_PLAYER,
	MANAGER,
}

const FASTEST_SPEED = 0.5
const FAST_SPEED = 0.7
const SLOW_SPEED = 1.3
const SLOWEST_SPEED = 1.5
const NORMAL_SPEED = 1.0

static func get_random_trait():
	return Type.values().pick_random()

static func get_trait_name(type: Type):
	return Type.keys()[type]

static func get_working_speed_multipler(type: Type):
	match type:
		Type.LAZY: return SLOWEST_SPEED
		Type.DILIGENT: return FASTEST_SPEED
		Type.PERFECTIONIST: return FAST_SPEED
		Type.TEAM_PLAYER: return SLOW_SPEED
	
	return NORMAL_SPEED
