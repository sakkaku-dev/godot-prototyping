class_name HoldPoint extends Node3D

@export var dir := Vector3.RIGHT
@export var grid: PackageGridMap

var holding: Node3D:
	set(v):
		if holding and holding.has_method("hold_release"):
			holding.hold_release()
		
		holding = v
		
		if holding and holding.has_method("hold"):
			holding.hold()

func is_holding():
	return holding != null

func place(pos: Vector3):
	var coord = grid.get_coord(pos)
	if not is_holding():
		var package = grid.remove_object(coord)
		if package:
			self.holding = package
	else:
		if grid.add_object(coord, holding):
			self.holding = null

func _process(_delta):
	if holding:
		holding.global_position = global_position
