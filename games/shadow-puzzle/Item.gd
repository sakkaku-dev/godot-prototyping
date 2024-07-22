class_name ShadowAlchemyItem
extends Area3D

signal picked_up()

enum Type {
	NITROGEN,
}

@export var type := Type.NITROGEN

func pick_up():
	picked_up.emit()
