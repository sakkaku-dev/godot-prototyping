extends NodeSpawner

@export var all_package_types: Array[PackageResource] = []

var package_types: Array[PackageResource] = []

func _ready():
	_add_random_package_type()
	
func _add_random_package_type():
	all_package_types.shuffle()
	
	for p in all_package_types:
		if p in package_types: continue
		
		package_types.append(p)
		break
	
	print("PackageSpawner with types %s" % [package_types.map(func(x): return PackageResource.Type.keys()[x.type])])

func _init_node(node):
	var pkg = node as Package
	pkg.res = package_types.pick_random()
