extends TextureButton

@export var label: RichTextLabel

var res: KnowledgeResource

func _ready():
	label.text = res.name
	
	modulate = Color.DIM_GRAY
	mouse_entered.connect(func():
		if not disabled:
			modulate = Color.WHITE
	)
	mouse_exited.connect(func(): 
		if not disabled:
			modulate = Color.DIM_GRAY
	)

func unlock():
	disabled = true
	label.text = "[s]%s[/s]" % res.name
	modulate = Color.DARK_GRAY
