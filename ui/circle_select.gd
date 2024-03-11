class_name ColorSelect
extends Control

signal selected(c)
signal cancel()

@export var inner_radius := 0.2
@export var count := 4
@export var cancel_btn: TextureButton
@export var press_threshold := 0.3

var cursor := Vector2(0, 0)
var time := 0.0

func _ready():
	material.set_shader_parameter("width_min", inner_radius)
	visibility_changed.connect(func(): time = 0.0)
	hide()

func _process(delta):
	if is_visible_in_tree():
		time += delta

func set_wheel_position(pos: Vector2):
	global_position = pos - size/2

func set_cursor_deg(deg: float):
	material.set_shader_parameter("cursor_deg", deg)

func get_center():
	return global_position + size/2

func _input(event: InputEvent):
	if not is_visible_in_tree():
		return
	
	if event is InputEventMouseMotion:
		var center = get_center()
		cursor = get_global_mouse_position() - center
		set_cursor_deg(get_cursor_angle())
	
	if event.is_action_pressed("action") or (event.is_action_released("action") and time >= press_threshold):
		var center = get_center()
		var radius = inner_radius * size.x
		var dist = center.distance_squared_to(get_global_mouse_position())
		if dist <= radius * radius:
			_cancel()
		else:
			selected.emit(get_selected_color())
			get_viewport().set_input_as_handled()
	#elif event.is_action_pressed("cancel"):
		#_cancel()
		#get_viewport().set_input_as_handled()
	
func _cancel():
	cancel.emit()

func get_cursor_angle():
	var angle = Vector2.UP.angle_to(cursor)
	if angle < 0:
		angle += TAU
	return angle

func get_cursor_index():
	if not count: return 0

	var angle = get_cursor_angle()
	var index_offset = TAU / count
	var to_return = angle / index_offset
	return floor(to_return)

func get_selected_color():
	var idx = get_cursor_index()
	return idx
