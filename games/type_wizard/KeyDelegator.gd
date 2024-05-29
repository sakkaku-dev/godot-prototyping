class_name KeyDelegator
extends Node

signal finished(typed_word)

@export var nodes: Array = []
@export var wpm_calc: WPMCalculator

var current_nodes := []:
	set(v):
		for node in current_nodes:
			if not node in v and node.has_method("set_typed"):
				node.set_typed("")
		
		current_nodes = v

var typed := ""

func remove_all():
	for n in nodes:
		n.queue_free()

	nodes = []
	cancel()

func handle_key(key: String):
	var word = typed + key
	var n = nodes if current_nodes.is_empty() else current_nodes
	var matches = _get_nodes_starting_with(n, word)
	#print("Typed: %s, Matches: %s" % [word, matches])

	self.current_nodes = matches
	if wpm_calc and word.length() == 1 and not current_nodes.is_empty():
		wpm_calc.start_type()
	
	if current_nodes.is_empty():
		cancel()
		return
	
	typed = word
	_update_typed()

func _update_typed():
	var found := false
	for node in current_nodes:
		if node.has_method("set_typed"):
			node.set_typed(typed)

		if node.get_word() == typed and not found:
			if wpm_calc:
				wpm_calc.finish_type(typed)
			finished.emit(node)
			found = true
			cancel()

func _get_nodes_starting_with(nodes: Array, text: String) -> Array:
	return nodes.filter(func(n): return n.has_method("get_word") and n.get_word().begins_with(text))

func cancel():
	self.current_nodes = []
	typed = ""
	
	if wpm_calc:
		wpm_calc.cancel_type()
