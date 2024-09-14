class_name GridItem

enum Type {
	CAULDRON,
	MATERIAL,
	TRASH,
	PREP_AREA,
}

var type: Type = -1

func _init(t: Type) -> void:
	type = t

func get_name():
	return Type.keys()[type]
