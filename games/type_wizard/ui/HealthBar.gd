extends HBoxContainer

@export var icon: Texture2D
@export var hurtbox: Hurtbox

func _ready():
	for c in get_children():
		remove_child(c)
	for i in range(hurtbox.health):
		_add_health()
	
	hurtbox.health_changed.connect(func(hp): _update_health(hp))
	
func _update_health(new_hp: int):
	for i in get_child_count():
		var child = get_child(i)
		child.scale = Vector2.ONE if i < new_hp else Vector2(0.75, 0.75)
		child.modulate = Color.WHITE if i < new_hp else Color.DIM_GRAY

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
