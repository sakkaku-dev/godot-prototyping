extends Node2D

@export var team_health: ProgressManualFill
@export var enemy_health: ProgressManualFill

@onready var map: TileMapLayer = $Map
@onready var teams: Node2D = $Teams
@onready var enemies: Node2D = $Enemies

func _ready() -> void:
	HoloIncData.character_action_changed.connect(func(c):
		_remove_character(c)

		if HoloIncData.character_actions[c] == HoloIncData.Action.FIGHT_TEAM:
			_add_character(c)
	)

	HoloIncData.team_health_changed.connect(func():
		var v = HoloIncData.team_health
		var max_v = HoloIncData.get_team_health()
		team_health.set_fill(v / max_v)
	)
	HoloIncData.enemy_health_changed.connect(func():
		var v = HoloIncData.enemy_health
		var max_v = HoloIncData.get_enemy_health(HoloIncData.map)
		enemy_health.set_fill(v / max_v)
	)
	
	HoloIncData.fighting_changed.connect(func(): _update_fight())
	_update_fight()

func _update_fight():
	team_health.visible = HoloIncData.team_health >= 0 #HoloIncData.is_fighting
	enemy_health.visible = HoloIncData.enemy_health >= 0 #HoloIncData.is_fighting
	enemies.visible = enemy_health.visible

func _add_character(c: String):
	for team in teams.get_children():
		if team.current_character == "":
			team.current_character = c
			break
	

func _remove_character(c: String):
	for team in teams.get_children():
		if team.current_character == c:
			team.current_character = ""
