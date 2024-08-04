extends SmoothContainer

@export var order_item: PackedScene

func _on_kfp_order_added(customer):
	var node = order_item.instantiate()
	node.customer = customer
	node.global_position = Vector2.RIGHT * 800
	add_child(node)

	node.removed.connect(func(): update_children_offsets())
	update_children_offsets()
