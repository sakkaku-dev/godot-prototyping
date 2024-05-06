class_name Interactable3D
extends Area3D

signal interacted()

func interact():
	interacted.emit()
