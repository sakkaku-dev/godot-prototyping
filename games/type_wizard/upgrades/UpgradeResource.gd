class_name UpgradeResource
extends Resource

@export var title := ""
@export var icon: Texture2D
@export var text := ""
@export var limit := 1

@export var unlock_upgrades: Array[UpgradeResource] = []
