extends TextureButton

@export var res: HookResource
@export var label: Label

func _ready():
	texture_normal = res.icon
	label.text = "%s" % res.price
