extends HBoxContainer

@onready var typed_word = $TypedWord
@onready var texture_rect = $TextureRect

var res: UpgradeResourceAttack

func _ready():
	if res:
		typed_word.word = res.title
		texture_rect.texture = res.icon

func handle_key(key: String):
	typed_word.handle_key(key)
