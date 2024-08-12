extends TextureButton

@export var res: ChickenResource
@export var label: Label
@onready var color_rect = $ColorRect

func _ready():
	KfpManager.chicken_assigned_changed.connect(func(_x): _update())
	visibility_changed.connect(func(): _update())

func _update():
	disabled = res in KfpManager.assigned_chickens
	modulate = Color.DIM_GRAY if disabled else Color.WHITE
	label.text = "%s" % res.name

func _process(delta):
	color_rect.visible = KfpManager.assigning_chicken == res
