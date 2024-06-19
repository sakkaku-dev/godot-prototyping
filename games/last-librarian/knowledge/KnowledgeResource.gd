class_name KnowledgeResource
extends Resource

enum Type {
	INDUSTRIAL,
	SCIENCE,
	SURVIVAL,
}

@export var name := ""
@export var description := ""
@export var chance_of_discovery := 0.0
#@export var required_knowledge: Array[KnowledgeResource] = []
@export var next_knowledge: Array[KnowledgeResource] = []
@export var type := Type.SCIENCE
