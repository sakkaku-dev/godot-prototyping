class_name KeyDelegator
extends Node

@export var nodes: Array = []

var current_node

func remove_all():
	for n in nodes:
		n.queue_free()
	current_node = null
	nodes = []

func handle_key(key: String):
	if current_node == null:
		for node in nodes:
			if not node.has_method("get_word") or not node.has_method("handle_key"): continue
			
			if node.get_word().begins_with(key):
				print("Using node %s for key %s" % [node.get_word(), key])
				current_node = node
				break
	
	if current_node:
		current_node.handle_key(key)

func cancel():
	if not current_node: return
	
	if current_node.has_method("reset"):
		current_node.reset()
	current_node = null
