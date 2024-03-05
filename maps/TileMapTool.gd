@tool
class_name TileMapTool
extends TileMap

@export var run := false:
	set(_x):
		if !Engine.is_editor_hint(): return
		do_run()

func do_run():
	pass
