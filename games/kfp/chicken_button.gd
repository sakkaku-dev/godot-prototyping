extends TextureButton

@onready var working_sign = $WorkingSign

var chicken: Chicken

func _ready():
	_update()
	
	focus_entered.connect(func(): chicken.modulate = Color.LIGHT_CORAL)
	focus_exited.connect(func(): chicken.modulate = Color.WHITE)
	
	pressed.connect(func():
		chicken.worker = not chicken.worker
		_update()
	)

func _update():
	working_sign.visible = chicken.worker

func _chicken_manager() -> ChickenManager:
	return get_tree().get_first_node_in_group(ChickenManager.GROUP)
