class_name ShopGridMap
extends GridMap

signal object_placed()

const CAULDRON = preload("res://games/coop/cauldron.tscn")
const MATERIAL_BOX = preload("res://games/coop/material_box.tscn")
const PREP_AREA = preload("res://games/coop/prep_area.tscn")
const TRASH = preload("res://games/coop/trash.tscn")

const ITEM_MAP = {
	GridItem.Type.CAULDRON: CAULDRON,
	GridItem.Type.MATERIAL: MATERIAL_BOX,
	GridItem.Type.PREP_AREA: PREP_AREA,
	GridItem.Type.TRASH: TRASH,
}

@export var default_layer := 1
@export var root: NavigationRegion3D

var data = {}

func _get_coord(pos: Vector2i):
	return Vector3i(pos.x, default_layer, pos.y)

func place(pos: Vector2i, item: GridItem) -> bool:
	var v = _get_coord(pos)
	if v in data:
		print("Already an object at %s" % v)
		return false
	
	if get_cell_item(v) != INVALID_CELL_ITEM:
		print("Already a tile at %s" % v)
		return false
	
	var node = ITEM_MAP[item.type].instantiate()
	data[v] = node
	root.add_child(node)
	node.global_position = map_to_local(v) + Vector3(0, -cell_size.y, 0)
	
	for prop in item.data:
		node.set(prop, item.data[prop])
	
	object_placed.emit()
	return true

func remove(pos: Vector2i):
	var v = _get_coord(pos)
	if not v in data:
		print("Nothing to remove at %s" % v)
		return
		
	var obj = data[v]
	root.remove_child(obj)
	data.erase(v)
