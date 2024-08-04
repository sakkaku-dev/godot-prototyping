class_name EmoteRoot
extends Node2D

@onready var emote = $Emote

func set_texture(tex):
	emote.texture = tex
