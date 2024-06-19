class_name LastLibrarian
extends Node2D

const INTRO_TEXT = [
	"In the distant future, the once mighty dominion of humanity lies on the brink of extinction, brought to the precipice by its own hubris and folly.",
	"The ravages of relentless wars, heedless exploitation of resources, and unchecked technological advancement have exacted a devastating toll on the planet and its inhabitants.",
	"Now, amidst the crumbling ruins of civilization, stripped of the knowledge that once defined its ascent, stands the Last Archiver.",
	"She holds within her possession the accumulated wisdom of millennia, preserved within the hallowed halls of her ancient archive.",
	"With this vast repository comes a solemn responsibility — to wield the power to restore or withhold, to guide or condemn. For she alone decides whether humanity will rise from its destruction or continue blindly towards demise."
]

enum Prophecy {
	ALIEN,
	METEORITE,
	PANDEMIC,
}

@onready var intro = $CanvasLayer/Intro
@onready var prophecy_ui = $CanvasLayer/ProphecyUI
@onready var knowledge_list = $CanvasLayer/KnowledgeList
@onready var next_decade = $CanvasLayer/NextDecade
@onready var knowledge_tree = $CanvasLayer/KnowledgeTree

@onready var gate = $TileMap/Gate

@onready var prophecy = Prophecy.values().pick_random()

@export var knowledges: Array[KnowledgeResource] = []

var selected_knowledge: KnowledgeResource

func _ready():
	intro.show_text(INTRO_TEXT)
	#intro.finished.connect(func():)
	knowledge_list.select_knowledge.connect(func(res):
		print("Selected knowledge %s" % res.name)
		selected_knowledge = res
		knowledge_list.close()
	)
	
	gate.interacted.connect(func(_a):
		if selected_knowledge:
			_give_knowledge(selected_knowledge)
	)

func _give_knowledge(knowledge: KnowledgeResource):
	if knowledge_tree.get_node_for(knowledge).is_unlocked():
		print("Knowledge %s already acquired" % knowledge.name)
		return
	
	#if _has_all_required_knowledge(knowledge):
	print("Learned knowledge %s" % knowledge.name)
	knowledge_tree.unlocked(knowledge)
	#else:
		#pending_knowledge.append(knowledge)
	
	selected_knowledge = null
	_process_decade()

func _has_all_required_knowledge(know: KnowledgeResource):
	for x in knowledge_tree.get_node_for(know).get_prev_nodes():
		if not x.is_unlocked():
			return false
	return true

func _process_decade():
	var discovered_knowledge = null
	var available = knowledge_tree.get_all_possible_auto_discovery()
	
	for n in available:
		if randf() < n.res.chance_of_discovery:
			discovered_knowledge = n.res
	
	if discovered_knowledge:
		knowledge_tree.unlocked(discovered_knowledge)
	
	next_decade.open()
