class_name Hand3D extends Area3D

@export var grid: PackageGridMap
@export var hold_point: Node3D

var holding: Package:
	set(v):
		if holding:
			holding.hold_release()
		
		holding = v
		
		if holding:
			holding.hold()

func is_holding():
	return holding != null

func place(pos: Vector3):
	if not is_holding():
		var package = grid.remove_package(pos)
		if package:
			self.holding = package
	else:
		if grid.add_package(pos, holding):
			self.holding = null

func _process(_delta):
	if holding:
		holding.global_position = hold_point.global_position
