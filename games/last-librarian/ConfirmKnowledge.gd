extends Control

signal confirm()

@export var label: RichTextLabel
@export var confirm_btn: Button
@export var cancal_btn: Button

var tw: Tween

func _ready():
	confirm_btn.pressed.connect(func(): confirm.emit())
	cancal_btn.pressed.connect(func(): close())
	
	hide()
	modulate = Color.TRANSPARENT

func open(res: KnowledgeResource):
	if res:
		label.text = "Give humanity the knowledge of %s?" % res.get_name_colored()
	else:
		label.text = "Don't give humanity any knowledge?"

	get_tree().paused = true
	show()
	tw = TweenCreator.create(self, tw)
	tw.tween_property(self, "modulate", Color.WHITE, 1.0)

func close():
	get_tree().paused = false
	tw = TweenCreator.create(self, tw)
	tw.tween_property(self, "modulate", Color.TRANSPARENT, 1.0)
	await tw.finished
	hide()
