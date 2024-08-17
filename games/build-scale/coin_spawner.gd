extends Marker3D

const COIN = preload("res://games/build-scale/coin.tscn")

func spawn():
	var node = COIN.instantiate()
	get_tree().current_scene.call_deferred("add_child", node)
	node.pos = global_position
	return node
