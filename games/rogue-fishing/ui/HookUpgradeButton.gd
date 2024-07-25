extends TextureButton

@export var res: HookResource
@export var label: Label

func _ready():
	texture_normal = res.sprite
	label.text = "%s" % res.price
