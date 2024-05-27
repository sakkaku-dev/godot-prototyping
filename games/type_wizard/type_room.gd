extends Node2D

@export var player: Node2D

@onready var room_manager: RoomManager = get_tree().get_first_node_in_group(RoomManager.GROUP)

@onready var left_door = $LeftDoor
@onready var right_door = $RightDoor
@onready var up_door = $UpDoor
@onready var down_door = $DownDoor

@onready var tile_map = $TileMap
@onready var enemy_spawner = $EnemySpawner

var enemies := 0
var move_dir: Vector2i

func _ready():
	var doors = [left_door, right_door, up_door, down_door]
	
	for d in doors:
		d.move.connect(func(dir):
			room_manager.coord += dir
			move_dir = dir
		)
		_update_door(d)
	
	enemy_spawner.enemy_removed.connect(func(e):
		enemies -= 1
		if enemies <= 0:
			room_manager.set_room_cleared()
			for d in doors:
				_update_door(d)
	)
	room_manager.changed.connect(func():
		await SceneManager.fade_out()
		var target_door = null
		for d in doors:
			_update_door(d)
			if d.dir == -move_dir:
				target_door = d
			
		if not room_manager.is_room_cleared():
			enemies = enemy_spawner.spawn_enemies(player)
		
		if target_door:
			player.global_position = target_door.global_position
		
		await get_tree().create_timer(0.5).timeout
		await SceneManager.fade_in()
	)

func _update_door(door):
	door.update(door.dir in room_manager.get_linked_dirs() and room_manager.is_room_cleared())
