class_name FishResource
extends Resource

enum Behaviour {
	MOVE,
	HIDE,
	ATTACK,
}

@export var name := ""
@export var sprite: Texture2D
@export var price := 1

@export var speed := 50
@export var behaviour := Behaviour.MOVE
