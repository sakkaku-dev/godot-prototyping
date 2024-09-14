class_name GridItem

enum Type {
	CAULDRON,
	MATERIAL,
	TRASH,
	PREP_AREA,
}

var type: Type = -1
var data = {}

func _init(t: Type, d = {}) -> void:
	type = t
	data = d

func get_name():
	return Type.keys()[type]
