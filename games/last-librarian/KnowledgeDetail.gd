class_name KnowledgeDetail
extends MarginContainer

@export var title: Label
@export var desc: Label
@export var panel: PanelContainer

func _ready():
	hide()

func show_for(res: KnowledgeResource, color: Color):
	if visible: # multiple nodes selected
		hide()
	
	var style = panel.get_theme_stylebox("panel")
	style.bg_color = color
	
	title.text = res.name
	desc.text = res.description
	show()
