extends DialogContaier

@onready var margin_container = $MarginContainer

func _ready():
	super._ready()
	show()
	modulate = Color.WHITE
	
	margin_container.modulate = Color.TRANSPARENT

func show_text(text: Array):
	all_text = text
	
	var tw = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tw.tween_property(margin_container, "modulate", Color.WHITE, 1.0).from(Color.TRANSPARENT)
	show()
	get_tree().paused = true
	
	_show_next()
