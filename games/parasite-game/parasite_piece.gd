class_name ParasitePiece
extends CharacterBody2D

signal do_action(action)
signal finished_move()

enum Action {
	MOVE,
	ATTACK,
	JUMP,
	STANDBY,
}

@onready var circle_select = $CircleSelect
@onready var color_rect = $ColorRect

var coord := Vector2i.ZERO
var id := 0
var infected := false:
	set(v):
		infected = v
		color_rect.modulate = Color.RED if infected else Color.WHITE

func _ready():
	circle_select.selected.connect(func(i):
		print("Action %s: %s" % [i, Action.keys()[i]])
		do_action.emit(i)
		circle_select.hide()
	)
	circle_select.cancel.connect(func(): circle_select.hide())

func set_colors(c1, c2, c3, c4):
	var mat = circle_select.material as ShaderMaterial
	mat.set_shader_parameter("color_1", c1)
	mat.set_shader_parameter("color_2", c2)
	mat.set_shader_parameter("color_3", c3)
	mat.set_shader_parameter("color_4", c4)

func open_action_select():
	circle_select.show()
func cancel():
	circle_select.hide()


func move_to(target: Vector2):
	var tw = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tw.tween_property(self, "global_position", target, 0.5)
	await tw.finished
	finished_move.emit()
func jump_to(target: Vector2):
	pass
func attack(target: Vector2):
	pass
func standby(target: Vector2):
	pass


func moveable_tiles(tilemap: FixedTileMap):
	return tilemap.get_neighbors(coord)
func attackable_tiles(tilemap: FixedTileMap):
	return tilemap.get_neighbors(coord, false)
func jumpable_tiles(tilemap: FixedTileMap):
	return tilemap.get_used_cells(tilemap.layer).filter(func(c): return (c.x == coord.x or c.y == coord.y) and coord != c)
