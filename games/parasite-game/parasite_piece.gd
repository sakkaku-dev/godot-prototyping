class_name ParasitePiece
extends CharacterBody2D

signal do_action(action)

enum Action {
	MOVE,
	ATTACK,
	JUMP,
	STANDBY,
}

@export var parasite_jump_scene: PackedScene
@export var attack_scene: PackedScene

@onready var circle_select = $CircleSelect
@onready var color_rect = $ColorRect
@onready var collision_shape_2d = $CollisionShape2D

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
func infect():
	self.infected = true


func move_to(target: Vector2):
	var tw = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tw.tween_property(self, "global_position", target, 0.5)
	await tw.finished

func jump_to(target: Vector2):
	var dir = global_position.direction_to(target)
	
	var node = _create_node(parasite_jump_scene, dir)
	node.from = self
	get_tree().current_scene.add_child(node)
	
	self.infected = false
	print("Jumped to %s" % dir)
	
	await node.reached

func attack(target: Vector2):
	var dir = global_position.direction_to(target)
	var node = _create_node(attack_scene, dir)
	get_tree().current_scene.add_child(node)
	await node.finished

func _create_node(scene: PackedScene, dir: Vector2):
	var node = scene.instantiate()
	node.global_position = global_position
	node.global_rotation = Vector2.RIGHT.angle_to(dir)
	return node

func moveable_tiles(tilemap: FixedTileMap):
	return tilemap.get_neighbors(coord)
func attackable_tiles(tilemap: FixedTileMap):
	return tilemap.get_neighbors(coord, false)
func jumpable_tiles(tilemap: FixedTileMap):
	return tilemap.get_used_cells(tilemap.layer).filter(func(c): return (c.x == coord.x or c.y == coord.y) and coord != c)
