extends Node2D

@onready var map: TileMapLayer = $Map
@onready var teams: Node2D = $Teams

func _ready() -> void:
	HoloIncData.character_action_changed.connect(func(c):
		_remove_character(c)

		if HoloIncData.character_actions[c] == HoloIncData.Action.FIGHT_TEAM:
			_add_character(c)
	)

func _add_character(c: String):
	for team in teams.get_children():
		if team.current_character == "":
			team.current_character = c
			break
	

func _remove_character(c: String):
	for team in teams.get_children():
		if team.current_character == c:
			team.current_character = ""
