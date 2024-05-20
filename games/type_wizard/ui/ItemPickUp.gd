class_name ItemPickUp
extends Dialog

@export var title_lbl: TypedWord
@export var icon: TextureRect
@export var desc_lbl: Label
@export var name_lbl: Label

func _ready():
	super._ready()
	title_lbl.type_finish.connect(func(): close())
	closed.connect(func(): title_lbl.reset())

func open_for_spells(title: String, item: SpellResource):
	title_lbl.word = title
	name_lbl.text = item.title
	desc_lbl.text = item.description
	if item.icon:
		icon.texture = item.icon
		
	open()

func handle_key(key: String, shift: bool):
	title_lbl.handle_key(key)
