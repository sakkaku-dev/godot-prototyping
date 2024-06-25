extends Node2D

@onready var bijou = $Bijou
@onready var marker_2d = $Marker2D

func _ready():
	bijou.spawn(marker_2d.global_position)
