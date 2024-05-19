extends HBoxContainer

@export var icon: Texture2D
@export var hurtbox: Hurtbox

func _ready():
	hurtbox.health_changed.connect(func(hp): _update_health(hp))
	_update_health(hurtbox.health)

func _update_health(new_hp: int):
	var delta = new_hp - get_child_count()
	if delta < 0:
		for i in range(abs(delta)):
			_remove_health()
	elif delta > 0:
		for i in range(delta):
			_add_health()

func _remove_health():
	if get_child_count() > 0:
		remove_child(get_child(0))

func _add_health():
	var rect = TextureRect.new()
	rect.texture = icon
	rect.expand_mode = TextureRect.EXPAND_FIT_HEIGHT
	rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	rect.custom_minimum_size = Vector2(10, 0)
	add_child(rect)
