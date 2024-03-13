extends PanelContainer

@export var container: Control
@export var row: PackedScene

func update(pieces: Array, turn: int):
	for c in container.get_children():
		container.remove_child(c)
	
	for i in range(pieces.size()):
		var piece = pieces[(turn + i) % pieces.size()]
		var node = row.instantiate()
		node.piece = piece
		container.add_child(node)
