extends Node2D

@onready var room_manager: RoomManager = get_tree().get_first_node_in_group(RoomManager.GROUP)

@onready var left_door = $LeftDoor
@onready var right_door = $RightDoor
@onready var up_door = $UpDoor
@onready var down_door = $DownDoor

func _ready():
	var doors = [left_door, right_door, up_door, down_door]
	
	for d in doors:
		d.move.connect(func(dir): room_manager.coord += dir)
	
	room_manager.changed.connect(func():
		for d in doors:
			d.update()
	)
