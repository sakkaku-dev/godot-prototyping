class_name KnowledgeNode
extends GraphNode

@export var connection_color = Color("#511b7d")
@export var selected_connection_color = Color("#511b7d")

@export var science_node_color = Color("#0f001c")
@export var military_node_color = Color("#0f001c")
@export var medicine_node_color = Color("#0f001c")

var res: KnowledgeResource

@onready var label = $Label
@onready var graph: GraphEdit = get_parent()

func _ready():
	label.text = res.name
	label.hide()
	name = res.name
	
	set_node_color(_get_node_color())
	node_selected.connect(func(): 
		set_slot_color_right(0, selected_connection_color)
		for n in get_next_nodes():
			n.set_slot_color_left(0, selected_connection_color)
	)
	node_deselected.connect(func():
		set_slot_color_right(0, connection_color)
		for n in get_next_nodes():
			n.set_slot_color_left(0, connection_color)
	)
	
func _get_node_color():
	match res.type:
		KnowledgeResource.Type.SCIENCE: return science_node_color
		KnowledgeResource.Type.INDUSTRIAL: return military_node_color
		KnowledgeResource.Type.SURVIVAL: return medicine_node_color

func unlock():
	label.show()
	selectable = true

func is_unlocked():
	return selectable

func set_node_color(c: Color):
	var style = get_theme_stylebox("panel").duplicate()
	style.bg_color = c
	add_theme_stylebox_override("panel", style)
	
	var style_selected = get_theme_stylebox("panel_selected").duplicate()
	var s = c.lightened(0.2)
	style_selected.bg_color = s
	add_theme_stylebox_override("panel_selected", style_selected)

func get_next_nodes():
	var result = []
	for c in graph.get_connection_list():
		if c.from_node == name:
			var n = graph.find_child_by_name(c.to_node)
			if n:
				result.append(n)
	return result
	
func get_prev_nodes():
	var result = []
	for c in graph.get_connection_list():
		if c.to_node == name:
			var n = graph.find_child_by_name(c.from_node)
			if n:
				result.append(n)
	return result
