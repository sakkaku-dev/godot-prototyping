class_name TilePlacement
extends BaseButton

signal changed_placing(placing: bool)

@export var placeholder: TilePlaceholder
@export var scene: PackedScene

var is_placing := false:
	set(v):
		is_placing = v
		if placeholder:
			placeholder.visible = v
		changed_placing.emit(v)

func _ready() -> void:
	self.is_placing = false
	pressed.connect(func(): self.is_placing = not is_placing)

func _unhandled_input(event):
	if not is_placing: return
	
	if event.is_action_pressed("ui_cancel"):
		self.is_placing = false
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("action") and placeholder:
		if not placeholder.is_valid_coord():
			print("Not valid position for egg")
			return
		
		place_at(placeholder.get_current_coord())

func place_at(coord: Vector2i):
	pass

func create_node():
	var node = scene.instantiate()
	node.global_position = placeholder.global_position
	placeholder.layer.add_child(node)
	return node
