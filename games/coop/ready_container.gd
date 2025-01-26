class_name ReadyContainer
extends MarginContainer

@export var player_container: Control

var nodes = {}

func _add_player(player: String):
	var tex = TextureRect.new()
	tex.texture = load("res://icon.svg")
	tex.custom_minimum_size = Vector2(32, 32)
	tex.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	tex.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	
	nodes[player] = tex
	player_container.add_child(tex)

func _remove_player(player: String):
	if not player in nodes: return
	nodes[player].queue_free()
	nodes.erase(player)

func set_ready(player: String, ready = false):
	if not ready:
		_remove_player(player)
	else:
		_add_player(player)

func reset():
	for c in player_container.get_children():
		c.queue_free()
