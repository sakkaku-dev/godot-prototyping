extends HBoxContainer

var piece: ParasitePiece

@onready var label = $Label
@onready var square = $TextureRect/Square
@onready var circle = $TextureRect/Circle
@onready var triangle = $TextureRect/Triangle

@onready var ICON_MAP = {
	Parasite.Type.ROCK: circle,
	Parasite.Type.PAPER: square,
	Parasite.Type.SCISSORS: triangle,
}

func _ready():
	ICON_MAP[piece.get_type()].show()
	label.text = "ID: %s" % piece.id
	modulate = Color.RED if piece.infected else Color.WHITE
