extends PanelContainer

signal finished()

@export var upgrade: UpgradeResource

@export_category("Nodes")
@export var title: TypedWord
@export var icon: TextureRect
@export var desc: Label

func _ready():
	if upgrade:
		title.word = upgrade.title
		desc.text = upgrade.text
		if upgrade.icon:
			icon.texture = upgrade.icon
	title.type_finish.connect(func(): finished.emit())

func handle_key(w: String):
	title.handle_key(w)

func reset():
	title.reset()
