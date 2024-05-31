extends GridMap

@export var size := Vector3i(10, 20, 10)
@export var noise: FastNoiseLite
@export var base_block = "building_17"

func _ready():
	clear()
	
	var base_item = mesh_library.find_item_by_name(base_block)

	for x in size.x:
		for z in size.z:
			#var v = noise.get_noise_2d(x, z)
			#var actual_v = remap(v, -1, 1, 0, size.y)
			#var height = ceil(actual_v)
			
			var n = randfn(size.y / 2, size.y * 0.2)
			var height = ceil(n) #randi_range(0, size.y)
			for y in height:
				set_cell_item(Vector3i(x, y, z), base_item)
	
