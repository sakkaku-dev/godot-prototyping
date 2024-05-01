class_name Interactable3D
extends Area3D

signal interacted(actor)

func interact(actor):
	interacted.emit(actor)
