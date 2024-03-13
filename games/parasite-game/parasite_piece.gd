class_name ParasitePiece
extends CharacterBody2D

signal highlight()
signal do_action(action)
signal died()

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
@onready var hurtbox = $Hurtbox
@onready var move_ray_cast = $MoveRayCast

var tilemap: FixedTileMap
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
	hurtbox.died.connect(func():
		died.emit()
		queue_free()
	)

func get_type():
	return hurtbox.type

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

func process(players: Array, others: Array):
	var player = players[0]
	
	var moves = moveable_tiles()
	print("Movable to %s" % [moves])
	if Parasite.winning_type(get_type()) == player.get_type():
		var result = _ai_run_away(player, moves)
		print("Run away from player to %s" % result)
		if result != null:
			await move_to_direction(result)
	else:
		var attack_coords = attackable_tiles()
		if player.coord in attack_coords and get_type() != player.get_type():
			print("Attacking player within range %s" % player.coord)
			await _ai_attack(player, moves)
		else:
			var result = _ai_move_to_player(player, moves)
			print("Moving towards player at %s to %s" % [player.coord, result])
			if result != null:
				await move_to_direction(result)
	
	await get_tree().create_timer(1.0).timeout

func _ai_run_away(player: ParasitePiece, moves: Array):
	return largest_distance(player.coord, moves)

func _ai_attack(player: ParasitePiece, moves: Array):
	attack(tilemap.map_to_local(player.coord))

func _ai_move_to_player(player: ParasitePiece, moves: Array):
	var largest = -100
	var result = null
	for move in moves:
		var new_dir = Vector2(player.coord - move)
		
		var h_dot = abs(new_dir.dot(Vector2.RIGHT))
		if h_dot > largest:
			largest = h_dot
			result = move
		
		var v_dot = abs(new_dir.dot(Vector2.UP))
		if v_dot > largest:
			largest = v_dot
			result = move
	return result

func smallest_distance(coord: Vector2i, moves: Array):
	var smallest_dist = 100000
	var result = null
	for move in moves:
		var new_dist = (coord - move).length()
		
		if new_dist < smallest_dist:
			smallest_dist = new_dist
			result = move
	return result
	
func largest_distance(coord: Vector2i, moves: Array):
	var largest_dist = -1
	var result = null
	for move in moves:
		var new_dist = (coord - move).length()
		
		if new_dist > largest_dist:
			largest_dist = new_dist
			result = move
	return result

func move_to_direction(c: Vector2i):
	var orig = coord
	coord = c
	var target = tilemap.map_to_local(c)
	move_ray_cast.target_position = target - global_position
	move_ray_cast.force_raycast_update()
	
	var x = move_ray_cast.get_collider()
	
	var return_coord = null
	var attack_coord = tilemap.local_to_map(target)
	if x:
		attack_coord = x.coord
		return_coord = x.coord - Vector2i(move_ray_cast.target_position.normalized())
	
	var tw = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tw.tween_property(self, "global_position", tilemap.map_to_local(attack_coord), 0.5)
	if return_coord != null:
		tw.tween_property(self, "global_position", tilemap.map_to_local(return_coord), 0.5)
	
	print("Moving from %s to %s, Returning %s" % [orig, attack_coord, return_coord])
	await tw.finished
	return attack_coord if return_coord == null else return_coord


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
	node.type = hurtbox.type
	if node.has_method("set_exclude"):
		node.set_exclude(hurtbox)
	if node.has_method("set_target"): # LaserAttack
		node.set_target(Vector2.RIGHT * global_position.distance_to(target))
	get_tree().current_scene.call_deferred("add_child", node)
	await node.finished

func _create_node(scene: PackedScene, dir: Vector2):
	var node = scene.instantiate()
	node.global_position = global_position
	node.global_rotation = Vector2.RIGHT.angle_to(dir)
	return node

func moveable_tiles(center = coord):
	return tilemap.get_neighbors(center)
func attackable_tiles(center = coord):
	return tilemap.get_used_cells(tilemap.layer).filter(func(c): return (c.x == center.x or c.y == center.y) and center != c)
func jumpable_tiles():
	if not infected: return []
	return tilemap.get_used_cells(tilemap.layer).filter(func(c): return (c.x == coord.x or c.y == coord.y) and coord != c)
