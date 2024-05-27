extends Control

@export var room_manager: RoomManager

func _ready():
	room_manager.changed.connect(func(): update())

func update():
	queue_redraw()
	
func _draw():
	for room in room_manager.rooms:
		var color = Color.WHITE
		if room == room_manager.boss_room:
			color = Color.RED
		elif room in room_manager.items:
			color = Color.GREEN
		elif room == room_manager.coord:
			color = Color.BLUE
		elif room == room_manager.spawn:
			color = Color.ORANGE
		elif room in room_manager.cleared:
			color = Color.GRAY
		
		draw_circle(Vector2(room) * Vector2(5, 5), 2, color)
