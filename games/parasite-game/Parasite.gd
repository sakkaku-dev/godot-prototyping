class_name Parasite
extends CharacterBody2D

enum Type {
	ROCK,
	PAPER,
	SCISSORS,
}

static var previous_type := Type.ROCK
static var spawned := 0

static func winning_type(type: Type):
	if type == Type.ROCK:
		return Type.SCISSORS
	elif type == Type.SCISSORS:
		return Type.PAPER
	return Type.ROCK

@export var rock_color: Color
@export var paper_color: Color
@export var scissors_color: Color
@export var type := Type.ROCK
@export var random_type := true
@export var player := false

@export var connection_count := 3
@export var connection_scene: PackedScene

#@onready var parasite_connection = $ParasiteConnection
#@onready var parasite_connection_2 = $ParasiteConnection2
#@onready var parasite_connection_3 = $ParasiteConnection3
@onready var color_rect = $ColorRect
@onready var auto_move = $AutoMove

#@onready var connections := [parasite_connection, parasite_connection_2, parasite_connection_3] 

func _ready():
	if random_type:
		if spawned < 3:
			type = winning_type(previous_type)
		else:
			type = Type.values().pick_random()
			
		previous_type = type
		spawned += 1
	
	var color = rock_color if type == Type.ROCK else (paper_color if type == Type.PAPER else scissors_color)
	var connections = []
	var angle := TAU / connection_count
	var dir := Vector2.RIGHT
	var offset: float = color_rect.size.x / 2.0
	
	for i in range(connection_count):
		var node = connection_scene.instantiate()
		node.position = dir * offset
		add_child(node)
		
		node.change_color(color)
		node.type = type
		node.angle = dir.angle()
		node.remove.connect(func(): queue_free())
		node.add.connect(func(other, pos): 
			other.call_deferred("connect_to", self, pos)
		)
		
		if player:
			node.monitoring = false
		
		dir = dir.rotated(angle)
	
	color_rect.modulate = color

func connect_to(parasite: Parasite, pos: Vector2):
	reparent(parasite)
	position = pos
	auto_move.enabled = false
