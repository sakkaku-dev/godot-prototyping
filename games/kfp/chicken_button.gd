extends TextureButton

@onready var working_sign = $WorkingSign

var chicken: Chicken

func _ready():
	_update()
	
	focus_entered.connect(func(): chicken.modulate = Color.LIGHT_CORAL)
	focus_exited.connect(func(): chicken.modulate = Color.WHITE)
	
	pressed.connect(func():
		if chicken.is_working():
			chicken.stop_work()
		else:
			chicken.start_work()
		
		_update()
	)

func _update():
	working_sign.visible = chicken.is_working()
