extends Area2D

signal add(parasite, pos)
signal remove()

@onready var color_rect = $ColorRect

var type : Parasite.Type

func _ready():
	area_entered.connect(func(x):
		if x.type == type:
			return
			
		if type == Parasite.winning_type(x.type):
			x.add_parasite(get_parent(), x.position)
		else:
			x.remove_parasite()
	)

func change_color(m: Color):
	modulate = m

func remove_parasite():
	remove.emit()

func add_parasite(parasite, pos):
	add.emit(parasite, pos)
