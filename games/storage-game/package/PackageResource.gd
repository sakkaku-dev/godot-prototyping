class_name PackageResource
extends Resource

enum Type {
	PAPER,
	CLOTHING,
	ELECTRONICS,
	FURNITURE,
}

@export var type := Type.PAPER
@export var weight := 1
