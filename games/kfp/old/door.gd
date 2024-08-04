extends Area2D

@export var side_door_close := Vector2(7, 2)
@export var side_door_open := Vector2(8, 2)

@export var front_door_close := Vector2(3, 1)
@export var front_door_open := Vector2(3, 2)

@export var front_door := false

@onready var sprite_2d = $Sprite2D
@onready var wall = $Wall/CollisionShape2D

func _ready():
	body_entered.connect(func(_x): _open())
	body_exited.connect(func(_x): _close())
	_close()
	
	if front_door:
		wall.disabled = true

func _open():
	sprite_2d.frame_coords = front_door_open if front_door else side_door_open
	
func _close():
	sprite_2d.frame_coords = front_door_close if front_door else side_door_close
