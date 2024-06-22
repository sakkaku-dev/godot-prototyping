class_name LastLibrarian
extends Node2D

const INTRO_TEXT = [
	"In the distant future, the once mighty dominion of humanity lies on the brink of extinction. The ravages of relentless wars, heedless exploitation of resources, and unchecked technological advancement have exacted a devastating toll on the planet and its inhabitants.",
	"Now, amidst the crumbling ruins of civilization, stripped of the knowledge that once defined its ascent, stands the Last Archiver. She holds within her possession the accumulated wisdom of millennia, preserved within the hallowed halls of her ancient archive.",
	"With this vast repository comes a solemn responsibility — to wield the power to restore or withhold, to guide or condemn. For she alone decides whether humanity will rise from its destruction or continue blindly towards demise."
]

var prophecy_endings = {
	Prophecy.ALIEN: load("res://games/last-librarian/prophecy/EndingAlien.tres"),
	Prophecy.METEORITE: load("res://games/last-librarian/prophecy/EndingMeteorite.tres"),
	Prophecy.PANDEMIC: load("res://games/last-librarian/prophecy/EndingPandemic.tres")
}

enum Prophecy {
	ALIEN,
	METEORITE,
	PANDEMIC,
}

@export var max_loop := 8
@export var selected_knowledge_label: Label
@export var knowledge_tree_btn: BaseButton

@onready var intro = $CanvasLayer/Intro
@onready var prophecy_ui = $CanvasLayer/ProphecyUI
@onready var knowledge_list = $CanvasLayer/KnowledgeList
@onready var next_decade = $CanvasLayer/NextDecade
@onready var knowledge_tree = $CanvasLayer/KnowledgeTree
@onready var gate = $Gate
@onready var gameover = $CanvasLayer/Gameover
@onready var bgm = $BGM

@onready var prophecy = Prophecy.values().pick_random()

var selected_knowledge: KnowledgeResource:
	set(v):
		selected_knowledge = v
		selected_knowledge_label.text = selected_knowledge.name if selected_knowledge else ""

var loop = 0
var button_tw: Tween

func _ready():
	self.selected_knowledge = null
	intro.open_with_text(INTRO_TEXT)
	intro.finished.connect(func():
		var tw = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		tw.tween_property(bgm, "volume_db", -20, 2.0).from(-40)
		bgm.play()
		intro.close()
	)

	knowledge_list.select_knowledge.connect(func(res):
		print("Selected knowledge %s" % (res.name if res else null))
		self.selected_knowledge = res
		knowledge_list.close()
	)
	
	gate.interacted.connect(func(_a): _give_knowledge(selected_knowledge))

func _give_knowledge(knowledge: KnowledgeResource):
	if knowledge:
		if knowledge_tree.get_node_for(knowledge).is_unlocked():
			print("Knowledge %s already acquired" % knowledge.name)
			return
		
		print("Learned knowledge %s" % knowledge.name)
		_unlocked_knowledge(knowledge)
	else:
		print("Continue without any knowledge")
	
	self.selected_knowledge = null
	_process_decade(knowledge)

func _unlocked_knowledge(res: KnowledgeResource):
	knowledge_tree.unlocked(res)
	knowledge_list.unlocked(res)

func _get_auto_discovered_knowledge():
	var discovered_knowledge = []
	var available = knowledge_tree.get_all_possible_auto_discovery()
	
	for n in available:
		if randf() < n.res.get_chance_of_discovery():
			discovered_knowledge.append(n.res)

	print("Auto discovered: %s" % [discovered_knowledge])
	return discovered_knowledge

func _move_button():
	button_tw = TweenCreator.create(knowledge_tree_btn, button_tw).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
	button_tw.tween_property(knowledge_tree_btn, "position", Vector2.LEFT * 5, 0.5)
	#button_tw.tween_property(knowledge_tree_btn, "position", Vector2.ZERO, 0.5)

func _process_decade(res: KnowledgeResource):
	get_viewport().gui_release_focus()
	
	var discovered_knowledge = _get_auto_discovered_knowledge()
	for k in discovered_knowledge:
		_unlocked_knowledge(k)
	
	loop += 1
	
	var days_left = max_loop - loop
	var msg = []
	if res:
		#_move_button()
		msg.append('You have given humanity the knowledge of %s' % res.get_name_colored())
	
	var is_end = loop >= max_loop
	if is_end:
		msg.append('The last decade has passed and the prophesied day has arrived.')
	else:
		var start = 'A' if (days_left >= max_loop - 1) else ['A', 'Another'].pick_random()
		if days_left > max_loop/2.:
			msg.append('%s decade has passed as humanity is advancing close to the prophesied day' % [start])
		else:
			msg.append('%s decade has gone by. Only %s decades is left until the prophesied day' % [start, days_left])
			

	if not discovered_knowledge.is_empty():
		var knowledge_text = ', '.join(discovered_knowledge.map(func(k): return k.get_name_colored()))
		msg.append('Humanity has discovered %s in the %s decade' % [knowledge_text, 'final' if is_end else 'past'])
	
	await next_decade.open_with_text(msg)
	await next_decade.finished
	
	if is_end:
		var ending = prophecy_endings[prophecy] as ProphecyEnding
		var ending_msg = []
		ending_msg.append(ending.desc_text)

		if knowledge_tree.is_knowledge_unlocked(ending.required_knowledge):
			ending_msg.append(ending.win_text)
		else:
			ending_msg.append(ending.lose_text)
		
		next_decade.set_bg_image(ending.background_image)
		next_decade.update_text(ending_msg)
		await next_decade.finished
		gameover.open()
	else:
		next_decade.close()
