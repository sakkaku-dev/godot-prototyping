class_name KnowledgeTree
extends Control

const FOLDER = "res://games/last-librarian/knowledge/"

@export var graph: GraphEdit
@export var node_scene: PackedScene

@export var science_container: PanelContainer
@export var industrial_container: PanelContainer
@export var survival_container: PanelContainer

var tw: Tween
var nodes = {}

func _ready():
	var set_panel = false
	for file in DirAccess.get_files_at(FOLDER):
		if not file.ends_with(".tres"): continue
		
		var knowledge = load(FOLDER + file)
		var node = node_scene.instantiate()
		node.res = knowledge
		graph.add_child(node)
		nodes[knowledge] = node
		
		if not set_panel:
			set_panel_color(science_container, node.science_node_color)
			set_panel_color(industrial_container, node.military_node_color)
			set_panel_color(survival_container, node.medicine_node_color)
			set_panel = true
		
	for node in graph.get_children():
		for k in node.res.next_knowledge:
			if k in nodes:
				graph.connect_node(node.name, 0, nodes[k].name, 0)
	
	await get_tree().create_timer(0.1).timeout
	graph.arrange_nodes()

func set_panel_color(panel: PanelContainer, color: Color):
	var style = panel.get_theme_stylebox("panel").duplicate()
	style.bg_color = color
	panel.add_theme_stylebox_override("panel", style)

func open():
	get_tree().paused = true
	tw = TweenCreator.create(self, tw)
	tw.tween_property(self, "modulate", Color.WHITE, 0.5).from(Color.TRANSPARENT)
	show()

func close():
	get_tree().paused = false
	tw = TweenCreator.create(self, tw)
	tw.tween_property(self, "modulate", Color.TRANSPARENT, 0.5)
	await tw.finished
	hide()

func _unhandled_input(event):
	if not visible: return
	
	if event.is_action_pressed("ui_cancel"):
		close()

func unlocked(knowledge: KnowledgeResource):
	get_node_for(knowledge).unlock()

func get_node_for(knowledge: KnowledgeResource):
	return graph.find_child_by_name(knowledge.name)

func get_all_finished_knowledge():
	var result = []
	
	var start = []
	for n in graph.get_children():
		if n.is_unlocked() and n.get_prev_nodes().is_empty():
			start.append(n)
			
		var required_nodes = n.get_prev_nodes()
		if required_nodes.is_empty() or required_nodes.filter(func(x): return x.is_unlocked()).size() > 0:
			result.append(n)
	
	return result

func get_all_possible_auto_discovery():
	var result = []
	
	for n in graph.get_children():
		if n.is_unlocked(): continue
		
		var required_nodes = n.get_prev_nodes()
		if required_nodes.is_empty():
			result.append(n)
			continue

		var is_fully_unlocked = true
		for x in required_nodes:
			if not is_fully_unlocked(x):
				is_fully_unlocked = false
				break
		
		if is_fully_unlocked:
			result.append(n)
	
	return result

func _is_all_unlocked(nodes: Array):
	for n in nodes:
		if not n.is_unlocked():
			return false
	return true

func is_fully_unlocked(node: KnowledgeNode):
	if not node.is_unlocked():
		return false
		
	var prev = node.get_prev_nodes()
	if prev.is_empty():
		return true
	
	for n in prev:
		if not is_fully_unlocked(n):
			return false
	return true

func is_knowledge_unlocked(knowledge: KnowledgeResource):
	var k = get_node_for(knowledge)
	return is_fully_unlocked(k)
