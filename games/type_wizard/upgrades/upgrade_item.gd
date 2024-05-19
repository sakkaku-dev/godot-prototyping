extends PanelContainer

@export var upgrade_res: UpgradeResource

@export_category("Nodes")
@export var title: TypedWord
@export var icon: TextureRect
@export var desc: Label

func _ready():
	if upgrade_res:
		title.word = upgrade_res.title
		icon.texture = upgrade_res.icon
		desc.text = upgrade_res.text

func handle_key(w: String):
	title.handle_key(w)

func cancel():
	title.reset()
