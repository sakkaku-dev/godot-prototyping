class_name ItemPickUp
extends Control

@export var pause: PauseBlur

@export_category("Internal Nodes")
@export var title_lbl: Label
@export var icon: TextureRect
@export var desc_lbl: Label
@export var name_lbl: Label

var tw: Tween

func _ready():
	pivot_offset = size / 2
	hide()

func open(title: String, item: SpellResource):
	show()
	pause.pause()
	
	title_lbl.text = title
	name_lbl.text = item.title
	desc_lbl.text = item.description
	icon.texture = item.icon
	
	tw = TweenCreator.create(self, tw)
	tw.tween_property(self, "scale", Vector2.ONE, 0.5).from(Vector2.ZERO)

func close():
	tw = TweenCreator.create(self, tw)
	tw.tween_property(self, "scale", Vector2.ZERO, 0.5)
	await tw.finished
	pause.resume()

func _unhandled_input(event):
	if not visible: return
	
	if event.is_action_pressed("ui_accept"):
		close()
