extends TextureButton

var level := 0

func _ready() -> void:
	HoloIncData.map_changed.connect(func(): _update())
	_update()

func _update():
	modulate = Color.DIM_GRAY if HoloIncData.get_count(HoloIncData.Item.MAP) > level else Color.WHITE
