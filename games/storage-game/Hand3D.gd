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
	if not grid.is_valid_position(pos):
		return
	
	var packages = grid.get_packages(pos)

	if not is_holding():
		if packages.size() > 0:
			var item = packages[0]
			self.holding = item
	else:
		var place_pos = grid.get_placement_position(pos)
		holding.place(place_pos)
		self.holding = null

func _process(_delta):
	if holding:
		holding.global_position = hold_point.global_position
