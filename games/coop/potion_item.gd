class_name PotionItem

const PROCESSES = {
	Process.CUTTING: {
		Type.HERB: Type.HERB_CUTTED,
	},
	Process.DISTILL: {
		Type.TEARS: Type.TEARS_DISTILL,
	},
	Process.COMBUST: {
		Type.STARLIGHT_DUST: Type.STARLIGHT_DUST_COMBUST,
	},
}

const RECIPIES = {
	Type.POTION_RED: [Type.FEATHER, Type.STARLIGHT_DUST_COMBUST],
	Type.POTION_BLUE: [Type.STARLIGHT_DUST, Type.FEATHER, Type.FEATHER],
	Type.POTION_GREEN: [Type.HERB_CUTTED, Type.HERB_CUTTED, Type.FEATHER],
}

const PRICES = {
	Type.POTION_RED: 10,
	Type.POTION_BLUE: 20,
	Type.POTION_GREEN: 30,
}

enum Process {
	CUTTING,
	DISTILL,
	COMBUST,
}

enum Type {
	FEATHER,
	HERB,
	HERB_CUTTED,
	TEARS,
	TEARS_DISTILL,
	STARLIGHT_DUST,
	STARLIGHT_DUST_COMBUST,
	
	POTION_RED,
	POTION_BLUE,
	POTION_GREEN,
}

var type: Type

var process_type: Process = -1
var processed := 0.0

func _init(item: Type):
	type = item

func get_name():
	return Type.keys()[type]

func get_price():
	if not type in PRICES: return 0
	return PRICES[type]

static func find_recipe(items: Array):
	for key in RECIPIES.keys():
		var recipe = RECIPIES[key]
		if contains_all(items, recipe):
			return key
	return null

static func contains_all(items: Array, types: Array):
	if items.size() != types.size():
		return false
	
	for x in items:
		if not x.type in types:
			return false
	return true
