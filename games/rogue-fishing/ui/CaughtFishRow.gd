extends Control

signal sell()

@export var fish: FishResource

@onready var texture_rect = $TextureRect
@onready var label = $Label
@onready var sell_btn = $SellBtn

func _ready():
	label.text = fish.name
	texture_rect.texture = fish.sprite
	
	sell_btn.toggled.connect(func(on):
		modulate = Color.DIM_GRAY if on else Color.WHITE
		sell.emit(on)
	)

func is_selling():
	return sell_btn.button_pressed
