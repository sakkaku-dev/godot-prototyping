class_name Interactable3D
extends Area3D

signal interacted(hand: Hand3D)

func interact(hand: Hand3D):
	interacted.emit(hand)

func action(hand: Hand3D, pressed: bool):
	pass
