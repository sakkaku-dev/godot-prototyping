# https://abitawake.com/news/articles/procedural-generation-with-godot-create-dungeons-using-a-bsp-tree
@tool
class_name BSPTreeDungeon
extends TileMapTool

signal tiles_updated

@export var map_w := 120
@export var map_h := 80
@export var min_room_size := 12
@export var min_room_factor := 0.4
@export var extend_bound := 10

var wall_source = 2
var wall_tile = Vector2i(0, 0)
var wall_terrain_set = 0
var wall_terrain_id = 0

var ground_source = 2
var ground_tile = Vector2i(10, 1)

var floor_layer = 0
var wall_layer = 1

var tree = {}
var leaves = []
var leaf_id = 0
var rooms = []

func do_run():
	generate()

func random_leaf():
	for id in tree:
		var leaf = tree[id]
		if _is_end_leaf(leaf):
			var c = leaf.center
			if _is_valid_floor(Vector2i(c.x, c.y)):
				return id

func _is_valid_floor(cell: Vector2i):
	return get_cell_source_id(floor_layer, cell) != -1

func get_leaf_center(id: int):
	var leaf = tree[id]
	if leaf:
		var c = leaf.center
		return map_to_local(Vector2i(c.x, c.y))
	
	return Vector2.ZERO

func farthest_leaf_from(leaf_id: int):
	var start_leaf = tree[leaf_id]
	if not start_leaf: return
	
	var leaf_center = Vector2(start_leaf.center.x, start_leaf.center.y)
	var dist = 0
	var farthest_leaf = -1
	
	for id in tree:
		var leaf = tree[id]
		if _is_end_leaf(leaf):
			var center = Vector2(leaf.center.x, leaf.center.y)
			
			if _is_valid_floor(center):
				var curr_dist = leaf_center.distance_to(center)
				if curr_dist > dist:
					dist = curr_dist
					farthest_leaf = id
	
	return farthest_leaf

func _is_end_leaf(leaf):
	return not leaf.has("l") and not leaf.has("r")

func generate():
	clear()
	start_tree()
	create_leaf(0)
	create_rooms()
	join_rooms()
	clear_deadends()
	fill_roof()
	
	for id in tree:
		print(tree[id])
	
	tiles_updated.emit()

func fill_roof():
	# Extend all sides by 1, in case the rooms are right at the border
	var cells = []
	var floor_tiles = get_used_cells(floor_layer)
	for x in range(-extend_bound, map_w + extend_bound):
		for y in range(-extend_bound, map_h + extend_bound):
			var coord = Vector2i(x, y)
			if not coord in floor_tiles:
				cells.append(coord)
			
	set_cells_terrain_connect(wall_layer, cells, wall_terrain_set, wall_terrain_id)

func start_tree():
	rooms = []
	tree = {}
	leaves = []
	leaf_id = 0

	tree[leaf_id] = { "x": 1, "y": 1, "w": map_w-2, "h": map_h-2 }
	leaf_id += 1

func create_leaf(parent_id):
	var x = tree[parent_id].x
	var y = tree[parent_id].y
	var w = tree[parent_id].w
	var h = tree[parent_id].h

	# used to connect the leaves later
	tree[parent_id].center = { x = floor(x + w/2), y = floor(y + h/2) }

	# whether the tree has space for a split
	var can_split = false

	# randomly split horizontal or vertical
	# if not enough width, split horizontal
	# if not enough height, split vertical
	var split_type = ['h', 'v'].pick_random()
	if   (min_room_factor * w < min_room_size):  split_type = "h"
	elif (min_room_factor * h < min_room_size):  split_type = "v"

	var leaf1 = {}
	var leaf2 = {}

	# try and split the current leaf,
	# if the room will fit
	if (split_type == "v"):
		var room_size = min_room_factor * w
		if (room_size >= min_room_size):
			var w1 = randi_range(room_size, (w - room_size))
			var w2 = w - w1
			leaf1 = { x = x, y = y, w = w1, h = h, split = 'v' }
			leaf2 = { x = x+w1, y = y, w = w2, h = h, split = 'v' }
			can_split = true
	else:
		var room_size = min_room_factor * h
		if (room_size >= min_room_size):
			var h1 = randi_range(room_size, (h - room_size))
			var h2 = h - h1
			leaf1 = { x = x, y = y, w = w, h = h1, split = 'h' }
			leaf2 = { x = x, y = y+h1, w = w, h = h2, split = 'h' }
			can_split = true

	# rooms fit, lets split
	if can_split:
		leaf1.parent_id    = parent_id
		tree[leaf_id]      = leaf1
		tree[parent_id].l  = leaf_id
		leaf_id += 1

		leaf2.parent_id    = parent_id
		tree[leaf_id]      = leaf2
		tree[parent_id].r  = leaf_id
		leaf_id += 1

		# append these leaves as branches from the parent
		leaves.append([tree[parent_id].l, tree[parent_id].r])

		# try and create more leaves
		create_leaf(tree[parent_id].l)
		create_leaf(tree[parent_id].r)

func create_rooms():
	for id in tree:
		var leaf = tree[id]
		if leaf.has("l"): continue # if node has children, don't build rooms

		if randf() <= 0.75:
			var room = {}
			room.id = id;
			room.w  = randi_range(min_room_size, leaf.w) - 1
			room.h  = randi_range(min_room_size, leaf.h) - 1
			room.x  = leaf.x + floor((leaf.w-room.w)/2) + 1
			room.y  = leaf.y + floor((leaf.h-room.h)/2) + 1
			room.split = leaf.split

			room.center = Vector2()
			room.center.x = floor(room.x + room.w/2)
			room.center.y = floor(room.y + room.h/2)
			rooms.append(room);

	# draw the rooms on the tilemap
	for i in range(rooms.size()):
		var r = rooms[i]
		for x in range(r.x, r.x + r.w):
			for y in range(r.y, r.y + r.h):
				set_ground(Vector2i(x, y))

func join_rooms():
	for sister in leaves:
		var a = sister[0]
		var b = sister[1]
		connect_leaves(tree[a], tree[b])

func connect_leaves(leaf1, leaf2):
	var x = min(leaf1.center.x, leaf2.center.x)
	var y = min(leaf1.center.y, leaf2.center.y)
	var w = 1
	var h = 1

	# Vertical corridor
	if (leaf1.split == 'h'):
		x -= floor(w/2.0)+1
		h = abs(leaf1.center.y - leaf2.center.y)
	else:
		# Horizontal corridor
		y -= floor(h/2.0)+1
		w = abs(leaf1.center.x - leaf2.center.x)

	# Ensure within map
	x = 0 if (x < 0) else x
	y = 0 if (y < 0) else y

	for i in range(x, x+w):
		for j in range(y, y+h):
			set_ground(Vector2i(i, j))

func set_ground(cell: Vector2i):
	set_cell(floor_layer, cell, ground_source, ground_tile)

func clear_deadends():
	var done = false

	while !done:
		done = true

		for cell in get_used_cells(floor_layer):
			var roof_count = check_nearby(cell.x, cell.y)
			if roof_count == 3:
				set_cell(floor_layer, cell, -1)
				done = false

# check in 4 dirs to see how many tiles are roofs
func check_nearby(x, y):
	var count = 0
	if get_cell_source_id(floor_layer, Vector2(x, y-1)) == -1:  count += 1
	if get_cell_source_id(floor_layer, Vector2(x, y+1)) == -1:  count += 1
	if get_cell_source_id(floor_layer, Vector2(x-1, y)) == -1:  count += 1
	if get_cell_source_id(floor_layer, Vector2(x+1, y)) == -1:  count += 1
	return count
