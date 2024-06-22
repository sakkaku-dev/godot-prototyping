extends Control

signal select_knowledge(knowledge)

@export var container: Control
@export var item_scene: PackedScene
@export var interactable: Interactable
@export var open_sound: AudioStreamPlayer
@export var close_sound: AudioStreamPlayer

const FOLDER = "res://games/last-librarian/knowledge/"

var tw: Tween
var map = {}

func _ready():
	for file in DirAccess.get_files_at(FOLDER):
		if not file.ends_with(".tres"): continue
		
		var knowledge = load(FOLDER + file)
		var node = item_scene.instantiate()
		node.res = knowledge
		map[node.res] = node
		node.pressed.connect(func(): select_knowledge.emit(knowledge))
		container.add_child(node)
		
	interactable.interacted.connect(func(_a):
		open()
		interactable.enabled = false
	)
	hide()

func unlocked(res: KnowledgeResource):
	map[res].unlock()

func _unhandled_input(event):
	if not visible or (tw and tw.is_running()):
		return
	
	if event.is_action_pressed("continue") or event.is_action_pressed("interact") or event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		close()

func open():
	open_sound.play()
	get_tree().paused = true
	tw = TweenCreator.create(self, tw)
	tw.tween_property(self, "modulate", Color.WHITE, 0.5).from(Color.TRANSPARENT)
	show()

func close():
	close_sound.play()
	get_tree().paused = false
	tw = TweenCreator.create(self, tw)
	tw.tween_property(self, "modulate", Color.TRANSPARENT, 0.5)
	await tw.finished
	hide()
	interactable.enabled = true
