class_name TakeOut
extends Node2D

const GROUP = "TakeOut"

@onready var interactable = $Interactable

func _ready():
	add_to_group(GROUP)
	
	interactable.interacted.connect(func(a: Hand): 
		if a.is_holding():
			if KFP.get_object(self).finished_order(a.item):
				a.hold_item(null)
	)
