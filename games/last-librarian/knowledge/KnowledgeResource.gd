class_name KnowledgeResource
extends Resource

enum Type {
	INDUSTRIAL,
	SCIENCE,
	SURVIVAL,
}

enum Chance {
	VERY_LOW = 5,
	LOW = 10,
	MEDIUM = 20,
	HIGH = 30,
	VERY_HIGH = 50,
}

@export var name := ""
@export var description := ""
@export var next_knowledge: Array[KnowledgeResource] = []
@export var type := Type.SCIENCE
@export var chance := Chance.VERY_LOW

func get_name_colored():
	return "[color=%s]%s[/color]" % [get_color_for_type(), name]
	
func get_color_for_type():
	match type:
		Type.SCIENCE: return "purple"
		Type.SURVIVAL: return "green"
		Type.INDUSTRIAL: return "red"

func get_chance_of_discovery():
	match chance:
		Chance.VERY_LOW: return 0.01
		Chance.LOW: return 0.05
		Chance.MEDIUM: return 0.15
		Chance.HIGH: return 0.3
		Chance.VERY_HIGH: return 0.5
