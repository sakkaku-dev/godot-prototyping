class_name Interactable3D
extends Area3D

signal holding()
signal holding_release()

@export var hold_point: Node3D

func get_object():
	return get_parent()

func hold():
	holding.emit()
	
func hold_release():
	holding_release.emit()
