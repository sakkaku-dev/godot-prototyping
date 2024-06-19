extends Control

@export var label: Label

var res: KnowledgeResource

func _ready():
	label.text = res.name
