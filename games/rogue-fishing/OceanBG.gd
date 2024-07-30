extends ColorRect

@export var colors: PackedColorArray
@export var limits: Array[int] = []
@export var transition_y := 300

@export_category("Canvas Modulate")
@export var canvas_mod: CanvasModulate
@export var from_color := Color.WHITE
@export var to_color := Color.BLACK
@export var start_darken_y := 5000
@export var darken_transition_y := 1000

@export var player: Node2D
@onready var start := player.global_position

func _ready():
	position = -size/2

func _process(delta):
	var player_y = global_position.y - start.y
	var target_color = get_interpolated_color(player_y)
	color = target_color
	
	if player_y > start_darken_y:
		var p = (player_y - start_darken_y) / darken_transition_y
		canvas_mod.color = from_color.lerp(to_color, p)

func get_interpolated_color(y_pos: float) -> Color:
	if y_pos < limits[0]:
		return Color.TRANSPARENT
	elif y_pos >= limits[-1]:
		return colors[-1]
	
	for i in range(limits.size() - 1):
		if y_pos >= limits[i] and y_pos < limits[i + 1]:
			var transition_start = limits[i + 1] - transition_y
			if y_pos < transition_start:
				return colors[i]
			var t = (y_pos - transition_start) / transition_y
			return colors[i].lerp(colors[i + 1], t)
	
	return colors[0]  # Fallback in case of unexpected values
