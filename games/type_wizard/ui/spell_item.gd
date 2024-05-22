extends HBoxContainer

signal cast()

var spell: SpellResource
var count := 0
var scroll := ""

@export var count_label: Label
@export var texture_rect: TextureRect 
@export var typed_word: TypedWord

func _ready():
	if spell:
		typed_word.word = scroll
		if spell.icon:
			texture_rect.texture = spell.icon
		count_label.text = "%sx" % count
	
	typed_word.type_finish.connect(func(): cast.emit())

func get_word():
	return typed_word.word

func handle_key(key: String):
	typed_word.handle_key(key)
