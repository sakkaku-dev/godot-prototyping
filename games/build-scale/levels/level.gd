class_name CoinLevel
extends Node3D

signal spawn_next(pos)

@onready var visible_on_screen_notifier_3d: VisibleOnScreenNotifier3D = $VisibleOnScreenNotifier3D
@onready var marker_3d: Marker3D = $Marker3D

#var pos: Vector3
#var flipped := false

#func _ready() -> void:
	#visible_on_screen_notifier_3d.screen_entered.connect(func(): spawn_next.emit(marker_3d.global_position))
	#global_position = pos
	#scale.x = -1 if flipped else 1
