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

const SPEED_FASTEST = 0.5
const SPEED_FAST = 0.7
const SPEED_SLOW = 1.3
const SPEED_SLOWEST = 1.5
const SPEED_NORMAL = 1.0

const EXHAUST_SLOW = 0.7
const EXHAUST_NORMAL = 1.0
const EXHAUST_FAST = 1.3

static func get_random_trait():
	return Type.values().pick_random()

static func get_trait_name(type: Type):
	return Type.keys()[type]

static func get_multiplier(types: Array, callable: Callable):
	return types.map(func(t): return callable.callv([t])).reduce(func(a, b): return a * b, 1.0)

static func get_working_speed_multipler(type: Type):
	match type:
		Type.LAZY: return SPEED_SLOWEST
		Type.DILIGENT: return SPEED_FASTEST
		Type.PERFECTIONIST: return SPEED_FAST
		Type.TEAM_PLAYER: return SPEED_SLOW
	
	return SPEED_NORMAL

static func get_exhaustion_multiplier(type: Type):
	match type:
		Type.LAZY: return EXHAUST_SLOW
		Type.DILIGENT: return EXHAUST_FAST
		 
	return EXHAUST_NORMAL
