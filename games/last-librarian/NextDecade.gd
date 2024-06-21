extends DialogContaier

@export var start_text: AutoTypedLabel
@onready var texture_rect = $Background2/TextureRect

func set_bg_image(img: Texture2D):
	texture_rect.modulate = Color.TRANSPARENT
	texture_rect.texture = img
	
	var tw = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tw.tween_property(texture_rect, "modulate", Color.WHITE, 1.0)
