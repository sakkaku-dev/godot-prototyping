extends HBoxContainer

@export var icon: Texture2D
@export var hurtbox: Hurtbox

func _ready():
	hurtbox.max_health_changed.connect(func(max): _update_max_health(max))
	hurtbox.health_changed.connect(func(hp): _update_health(hp))
	
	_update_max_health()
	
func _update_health(new_hp: int = hurtbox.health):
	for i in get_child_count():
		var child = get_child(i)
		child.scale = Vector2.ONE if i < new_hp else Vector2(0.75, 0.75)
		child.modulate = Color.WHITE if i < new_hp else Color.DIM_GRAY

func _update_max_health(new_max: int = hurtbox.max_health):
	var delta = new_max - get_child_count()
	if delta < 0:
		for i in range(abs(delta)):
			_remove_health()
	elif delta > 0:
		for i in range(delta):
			_add_health()
		
	_update_health()

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
	rect.pivot_offset = rect.size / 2
