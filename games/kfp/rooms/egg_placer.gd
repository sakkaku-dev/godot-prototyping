extends TilePlacement

@export var hatch_value := 1000.0

func place_at(coord: Vector2i):
	if KfpManager.place_egg(coord, hatch_value):
		var node = create_node()
		node.coord = coord

		if KfpManager.get_item_count(KfpUpgradeManager.EGG) <= 0:
			self.is_placing = false
