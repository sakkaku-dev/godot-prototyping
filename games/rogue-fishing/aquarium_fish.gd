extends CharacterBody2D

@export var fish: FishResource

@onready var sprite_2d = $Sprite2D
@onready var idle_timer = $IdleTimer

func _ready():
	sprite_2d.texture = fish.sprite
