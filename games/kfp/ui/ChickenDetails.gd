class_name ChickenDetails
extends PanelContainer

signal butcher_chicken(res)

@export var editable := false
@export var res: ChickenResource

@export var name_label: Label
@export var traits_label: Label
@export var butcher_button: BaseButton

func _ready():
	hide()
	butcher_button.pressed.connect(func(): butcher_chicken.emit(res))
	butcher_button.visible = editable

func show_chicken(chicken: ChickenResource):
	if chicken == null:
		hide()
		return
	
	res = chicken
	name_label.text = "%s" % res.name
	traits_label.text = "%s" % KfpManager.Traits.keys()[res.traits[0]]
	show()
