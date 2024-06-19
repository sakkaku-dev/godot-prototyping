extends GraphEdit

func find_child_by_name(n: String):
	for c in get_children():
		if c.name == n:
			return c
	
	print("Failed to find %s" % n)
	return null
